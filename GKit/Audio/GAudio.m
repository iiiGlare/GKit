//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "GAudio.h"
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>

#import "GCore.h"

@interface GAudio ()
<AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSURL *audioRecordingFileURL;
@property (nonatomic, strong) NSTimer *audioRecordingTimer;
@property (nonatomic, copy) void (^audioRecordingCallback)(NSTimeInterval currentTime, BOOL recording, BOOL interruption, NSError *error);

@property (nonatomic, strong) AVAudioSession *audioSession;

@end

@implementation GAudio

#pragma mark - Init

+ (GAudio *)sharedAudio
{
    static GAudio *_sharedAudio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAudio = [[GAudio alloc] init];
    });
    return _sharedAudio;    
}

- (id)init
{
    self = [super init];
    if (self) {
        self.audioRecordingFileURL = [GCachesDirectoryURL() URLByAppendingPathComponent:@"AudioRecording.caf"];
        self.audioSession = [AVAudioSession sharedInstance];
    }
    return self;
}

#pragma mark - Play

+ (void)vibrate
{
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

+ (void)playSystemSoundForResource:(NSString *)resource
					 withExtension:(NSString *)extension
{
	CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
	NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: resource
                                                withExtension: extension];
	
    // Store the URL as a CFURLRef instance
	soundFileURLRef = (CFURLRef) CFBridgingRetain(tapSound);
	
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
									  soundFileURLRef,
									  &soundFileObject
									  );
	AudioServicesPlaySystemSound (soundFileObject);
	CFBridgingRelease(soundFileURLRef);
}
+ (void)playMusicWithContentsOfURL:(NSURL *)fileURL volume:(CGFloat)volume
{
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
																	  error:nil];
	newPlayer.volume = volume;
	newPlayer.delegate = [GAudio sharedAudio];
	[newPlayer prepareToPlay];
	[newPlayer setCurrentTime:0];
	[newPlayer play];
    [[GAudio sharedAudio] setAudioPlayer:newPlayer];
}

+ (void)stopPlayMusic
{
    [[[GAudio sharedAudio] audioPlayer] stop];
    [[GAudio sharedAudio] setAudioPlayer:nil];
}

//AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	self.audioPlayer = nil;
}

#pragma mark - Record
+ (void)prepareRecordingWithCallback:(void (^)(NSTimeInterval currentTime, BOOL recording, BOOL interruption, NSError *error))callback
{
    [[GAudio sharedAudio] prepareRecordingWithCallback:callback];
}
+ (void)startRecording
{
    [[GAudio sharedAudio] startRecording];
}
+ (void)pauseRecording
{
    [[GAudio sharedAudio] pauseRecording];
}
+ (void)stopAndMoveRecordedAudioFileToURL:(NSURL *)url
{
    [[GAudio sharedAudio] stopAndMoveRecordedAudioFileToURL:url];
}
+ (void)stopAndDeleteRecording
{
    [[GAudio sharedAudio] stopAndDeleteRecording];
}

- (void)prepareRecordingWithCallback:(void (^)(NSTimeInterval currentTime, BOOL recording, BOOL interruption, NSError *error))callback
{
    self.audioRecordingCallback = callback;
    
    NSError *error;
    AVAudioRecorder *audioRecorder =
    [[AVAudioRecorder alloc] initWithURL: self.audioRecordingFileURL
                                settings: @{ AVFormatIDKey: GNumberWithInt(kAudioFormatLinearPCM),
                                           AVSampleRateKey: GNumberWithFloat(8000.0),
                                     AVNumberOfChannelsKey: GNumberWithInt(1),
                                    AVLinearPCMBitDepthKey: GNumberWithInteger(16),
                                 AVLinearPCMIsBigEndianKey: GNumberWithBOOL(NO),
                                     AVLinearPCMIsFloatKey: GNumberWithBOOL(NO) }
                                   error: &error];
    
    //
    if (!audioRecorder) {
        GPRINT(@"Error establishing recorder: %@", error.localizedFailureReason);
        _audioRecordingCallback(0, NO, NO, error);
        return;
    }

    //
    BOOL inputAvailable;
    if ([UIDevice isOSVersionHigherThanVersion:@"6.0" includeEqual:YES]) {
        inputAvailable = self.audioSession.inputAvailable;
    }else {
        inputAvailable = self.audioSession.inputIsAvailable;
    }
    if (!inputAvailable) {
        GPRINT(@"Audio input hardware not available");
        NSError *error = [[NSError alloc] initWithDomain: @"GAudioRecordingError"
                                                    code: 0
                                                userInfo: nil];
        _audioRecordingCallback(0, NO, NO,error);
        return;
    }
    
    //
    audioRecorder.delegate = self;
    [audioRecorder prepareToRecord];
    self.audioRecorder = audioRecorder;
}

- (void)startRecording
{
    [self.audioRecorder record];
    
    self.audioRecordingTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                                target: self
                                                              selector: @selector(audioRecordingTimerDidFire)
                                                              userInfo: nil
                                                               repeats: YES];
    [self.audioRecordingTimer fire];
}

- (void)audioRecordingTimerDidFire
{
    _audioRecordingCallback(_audioRecorder.currentTime, _audioRecorder.recording, NO, nil);
}

- (void)pauseRecording
{
    [self.audioRecordingTimer invalidate];
    self.audioRecordingTimer = nil;

    [self audioRecordingTimerDidFire];
    
    [self.audioRecorder pause];
    
}

- (void)stopAndMoveRecordedAudioFileToURL:(NSURL *)url
{
    self.audioRecorder.delegate = nil;
    [self.audioRecordingTimer invalidate];
    self.audioRecordingTimer = nil;
    
    [self audioRecordingTimerDidFire];

    //stop
    [self.audioRecorder stop];
    
    //move
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL: url
                                              error: &error];
    if (error) {
        GPRINTError(error);
    }
    error = nil;
    [[NSFileManager defaultManager] copyItemAtURL: self.audioRecordingFileURL
                                            toURL: url
                                            error: &error];
    if (error) {
        GPRINTError(error);
    }
    
    //delete
    [self.audioRecorder deleteRecording];
    self.audioRecorder = nil;
    self.audioRecordingCallback = nil;
}

- (void)stopAndDeleteRecording
{
    self.audioRecorder.delegate = nil;
    [self.audioRecordingTimer invalidate];
    self.audioRecordingTimer = nil;
    
    [self audioRecordingTimerDidFire];
    
    //stop
    [self.audioRecorder stop];
    
    //delete
    [self.audioRecorder deleteRecording];
    self.audioRecorder = nil;
    self.audioRecordingCallback = nil;
}

//AVAudioRecorderDelegate
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    _audioRecordingCallback(_audioRecorder.currentTime, _audioRecorder.recording, YES, nil);
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    _audioRecordingCallback(_audioRecorder.currentTime, _audioRecorder.recording, NO, nil);
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
    _audioRecordingCallback(_audioRecorder.currentTime, _audioRecorder.recording, NO, nil);
}

#pragma mark - AVAudioSession

+ (void)activeAudioSession
{
	//activating
	NSError *activationError = nil;
	[[[GAudio sharedAudio] audioSession] setActive:YES error:&activationError];
}

+ (void)deactiveAudioSession
{
	//activating
	NSError *activationError = nil;
	[[[GAudio sharedAudio] audioSession] setActive:NO error:&activationError];
}

+ (void)setSessionProperty:(AudioSessionCategory)category
{
	NSString *theCategory = nil;
	//3.0 and later
	if ([UIDevice isOSVersionHigherThanVersion:@"3.0" includeEqual:YES]) {
		switch (category) {
			case AudioSessionCategoryAmbient:
				theCategory = AVAudioSessionCategoryAmbient;
				goto next;
			case AudioSessionCategorySoloAmbient:
				theCategory = AVAudioSessionCategorySoloAmbient;
				goto next;
			case AudioSessionCategoryPlayback:
				theCategory = AVAudioSessionCategoryPlayback;
				goto next;
			case AudioSessionCategoryRecord:
				theCategory = AVAudioSessionCategoryRecord;
				goto next;
			case AudioSessionCategoryPlayAndRecord:
				theCategory = AVAudioSessionCategoryPlayAndRecord;
				goto next;
			default:
				break;
		}
		//3.1 and later
		if ([UIDevice isOSVersionHigherThanVersion:@"3.1" includeEqual:YES]) {
			if (category == AudioSessionCategoryAudioProcessing) {
				theCategory = AVAudioSessionCategoryAudioProcessing;
				goto next;
			}
			//6.0 and later
			if ([UIDevice isOSVersionHigherThanVersion:@"6.0" includeEqual:YES]) {
				if (category == AudioSessionCategoryMultiRoute) {
					theCategory = AVAudioSessionCategoryMultiRoute;
					goto next;
				}
			}
		}
	}
next:
	if (theCategory) {
		
		if ([[[GAudio sharedAudio] audioSession].category isEqualToString:theCategory]) {
			return;
		}
		
		[GAudio deactiveAudioSession];
		//setting the category
		NSError *setCategoryError = nil;
		[[[GAudio sharedAudio] audioSession] setCategory:theCategory error:&setCategoryError];
		[GAudio activeAudioSession];
	}
}
+ (void)overrideCategoryDefaultToSpeaker:(BOOL)isOverride
{
    //
	OSStatus propertySetError = 0;
	UInt32 allowOverride = true;
	if (isOverride==NO) {
		[GAudio setSessionProperty:AudioSessionCategoryPlayAndRecord];
		allowOverride = false;
	}
    
	//get property to detect whether need to set it
	UInt32 currentOverride;
	UInt32 size = sizeof(currentOverride);
	AudioSessionGetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
							&size,
							&currentOverride);
	if (allowOverride==currentOverride)
		return;
	
	[GAudio deactiveAudioSession];
	propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
											   sizeof(allowOverride),
											   &allowOverride);
	
	[GAudio activeAudioSession];
	
}
+ (void)overrideAudioRouteToSpeaker:(BOOL)isOverride
{
	//
	OSStatus propertySetError = 0;
	UInt32 allowOverride = kAudioSessionOverrideAudioRoute_None;
	if (isOverride==YES) {
//		[GAudio setSessionProperty:AudioSessionCategoryPlayAndRecord];
		allowOverride = kAudioSessionOverrideAudioRoute_Speaker;
	}
	
	//get property to detect whether need to set it
	UInt32 currentOverride;
	UInt32 size = sizeof(currentOverride);
	AudioSessionGetProperty(kAudioSessionProperty_OverrideAudioRoute,
							&size,
							&currentOverride);
	if (allowOverride==currentOverride)
		return;
	
	[GAudio deactiveAudioSession];
	propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,
											   sizeof(allowOverride),
											   &allowOverride);
	
	[GAudio activeAudioSession];
	
}
+ (BOOL)isSilenced {
#if TARGET_IPHONE_SIMULATOR
	// return NO in simulator. Code causes crashes for some reason.
	return NO;
#endif
	
	if ([UIDevice isOSVersionLowerThanVersion:@"5.0" includeEqual:NO]) {
		CFStringRef state;
		UInt32 propertySize = sizeof(CFStringRef);
		AudioSessionGetProperty(kAudioSessionProperty_AudioRoute,
								&propertySize,
								&state);
		
		if(CFStringGetLength(state) > 0)
			return NO;
		else
			return YES;
	}else{
		
		CFDictionaryRef asCFType = nil;
		UInt32 dataSize = sizeof(asCFType);
		AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &asCFType);
		NSDictionary *easyPeasy = (__bridge NSDictionary *)asCFType;
		NSArray *outputs = [easyPeasy valueForKey:(__bridge NSString *)kAudioSession_AudioRouteKey_Outputs];
        //		NSDictionary *firstOutput = (NSDictionary *)[ objectAtIndex:0];
        //		NSString *portType = (NSString *)[firstOutput valueForKey:@"RouteDetailedDescription_PortType"];
        //		NSLog(@"first output port type is: %@!", portType);
		NSLog(@"%@",outputs);
		
        //		CFDictionaryRef dic;
        //		UInt32 propertySize = sizeof(CFDictionaryRef);
        //		AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription,
        //								&propertySize,
        //								&dic);
        //
        //		if(CFDictionaryGetValue(<#CFDictionaryRef theDict#>, <#const void *key#>)(state) > 0)
        //			return NO;
        //		else
        //			return YES;
		return NO;
	}
}
@end
