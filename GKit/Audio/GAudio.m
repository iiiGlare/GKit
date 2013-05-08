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
+ (BOOL)recordAudioAtURL:(NSURL *)fileURL
{
    NSError *error;
    AVAudioRecorder *audioRecorder =
    [[AVAudioRecorder alloc] initWithURL: fileURL
                                settings: @{ AVFormatIDKey: GNumberWithInt(kAudioFormatLinearPCM),
                         AVSampleRateKey: GNumberWithFloat(8000.0),
                   AVNumberOfChannelsKey: GNumberWithInt(1),
                  AVLinearPCMBitDepthKey: GNumberWithInteger(16),
               AVLinearPCMIsBigEndianKey: GNumberWithBOOL(NO),
                   AVLinearPCMIsFloatKey: GNumberWithBOOL(NO)
     }
                                   error: &error];
    if (!audioRecorder) {
        GPRINT(@"Error establishing recorder: %@", error.localizedFailureReason);
        return NO;
    }
    
    audioRecorder.delegate = [GAudio sharedAudio];
    [audioRecorder prepareToRecord];
    [GAudio sharedAudio].audioRecorder = audioRecorder;
    
    BOOL inputAvailable;
    if ([UIDevice isOSVersionHigherThanVersion:@"6.0" includeEqual:YES]) {
        inputAvailable = [GAudio sharedAudio].audioSession.inputAvailable;
    }else {
        inputAvailable = [GAudio sharedAudio].audioSession.inputIsAvailable;
    }
    if (!inputAvailable) {
        GPRINT(@"Audio input hardware not available");
        return NO;
    }
    
    return [audioRecorder record];
}

+ (void)startRecording
{
    [[[GAudio sharedAudio] audioRecorder] record];
}
+ (void)pauseRecording
{
    [[[GAudio sharedAudio] audioRecorder] pause];
}
+ (void)stopRecording
{
    [[[GAudio sharedAudio] audioRecorder] stop];
}
+ (void)deleteRecording
{
    [[[GAudio sharedAudio] audioRecorder] deleteRecording];
}

//
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    [GAudio pauseRecording];
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
    
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
