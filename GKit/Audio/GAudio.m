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
#import "GCore.h"

@interface GAudio ()
<AVAudioPlayerDelegate, AVAudioRecorderDelegate>

//
@property (nonatomic, copy) void (^blockAudioPlayingCallback)(GAudio *audio, GAudioInterruptionType type, NSError *error);
@property (nonatomic, copy) void (^blockAudioFinishCallback)(GAudio *audio, BOOL successfully);
@property (nonatomic, strong) CADisplayLink * audioPlayingTimer;

//
@property (nonatomic, strong) NSURL * audioRecordingFileURL;
@property (nonatomic, strong) CADisplayLink * audioRecordingTimer;
@property (nonatomic, copy) void (^blockAudioRecordingCallback)(GAudio *audio, GAudioInterruptionType type, NSError *error);

//
@property (nonatomic, strong) AVAudioSession *audioSession;

@end

@implementation GAudio

#pragma mark - Vibrate && SystemSound
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

+ (void)setSessionProperty:(GAudioSessionCategory)category
{
	NSString *theCategory = nil;
	//3.0 and later
	if ([UIDevice isOSVersionHigherThanVersion:@"3.0" includeEqual:YES]) {
		switch (category) {
			case GAudioSessionCategoryAmbient:
				theCategory = AVAudioSessionCategoryAmbient;
				goto next;
			case GAudioSessionCategorySoloAmbient:
				theCategory = AVAudioSessionCategorySoloAmbient;
				goto next;
			case GAudioSessionCategoryPlayback:
				theCategory = AVAudioSessionCategoryPlayback;
				goto next;
			case GAudioSessionCategoryRecord:
				theCategory = AVAudioSessionCategoryRecord;
				goto next;
			case GAudioSessionCategoryPlayAndRecord:
				theCategory = AVAudioSessionCategoryPlayAndRecord;
				goto next;
			default:
				break;
		}
		//3.1 and later
		if ([UIDevice isOSVersionHigherThanVersion:@"3.1" includeEqual:YES]) {
			if (category == GAudioSessionCategoryAudioProcessing) {
				theCategory = AVAudioSessionCategoryAudioProcessing;
				goto next;
			}
			//6.0 and later
			if ([UIDevice isOSVersionHigherThanVersion:@"6.0" includeEqual:YES]) {
				if (category == GAudioSessionCategoryMultiRoute) {
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
		[GAudio setSessionProperty:GAudioSessionCategoryPlayAndRecord];
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

+ (GAudio *)newAudio
{
    return [[GAudio alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.audioSession = [AVAudioSession sharedInstance];
        
        self.audioRecordingFileURL = [GCachesDirectoryURL() URLByAppendingPathComponent:@"AudioRecording.caf"];
        
    }
    return self;
}

#pragma mark - Playing

- (void)preparePlayingWithContents:(id)audioContents
                          callback:(void (^)(GAudio *audio, GAudioInterruptionType type, NSError *error))callback
                            finish:(void (^)(GAudio *audio, BOOL successfully))finish;
{
    self.blockAudioPlayingCallback = callback;
    self.blockAudioFinishCallback = finish;
    
    NSError *error = nil;
    
    //创建audioPlayer
    if ([audioContents isKindOfClass:[NSData class]]) {
        _player = [[AVAudioPlayer alloc] initWithData:audioContents
                                                error:&error];
    }else {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioContents
                                                         error:&error];
    }
    
    //准备播放
    if (error) {
        //创建失败
        GPRINTError(error);
        
        if (_blockAudioPlayingCallback) {
            _blockAudioPlayingCallback(self, GAudioInterruptionNone, error);
        }
        
        [self deletePlaying];
    }else {
        
        //创建成功并播放
        if (![_player prepareToPlay]) {
            
            //无法播放
            
            GPRINT(@"AVAudioPlayer failed prepareToPlay");
            
            NSError *error = [[NSError alloc] initWithDomain: @"GAudioPlayingError"
                                                        code: 0
                                                    userInfo: nil];
            if (_blockAudioPlayingCallback) {
                _blockAudioPlayingCallback(self, GAudioInterruptionNone, error);
            }
            
            [self deletePlaying];
        }
    }

}
- (void)startPlayingWithCurrentTime:(NSTimeInterval)currentTime
{
    _player.delegate = self;
    _player.currentTime = currentTime;
    
    if ([_player play]) {
        
        //播放成功并创建反馈
        if (_blockAudioPlayingCallback) {
            self.audioPlayingTimer =
            [CADisplayLink displayLinkWithTarget:self selector:@selector(audioPlayingTimerDidFire)];
            [_audioPlayingTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }else {
        //播放失败
        
        GPRINT(@"AVAudioPlayer failed play");
        NSError *error = [[NSError alloc] initWithDomain: @"GAudioPlayingError"
                                                    code: 0
                                                userInfo: nil];
        if (_blockAudioPlayingCallback) {
            _blockAudioPlayingCallback(self, GAudioInterruptionNone, error);
        }
        
        [self deletePlaying];
    }
}

- (void)audioPlayingTimerDidFire
{
    if (_blockAudioPlayingCallback) {
        _blockAudioPlayingCallback(self, GAudioInterruptionNone, nil);
    }
}

- (void)pausePlaying
{
    [_player pause];
    
    [self.audioPlayingTimer invalidate];
    self.audioPlayingTimer = nil;
}
- (void)stopPlaying
{
    [_player stop];
    _player.delegate = nil;
    
    [self.audioPlayingTimer invalidate];
    self.audioPlayingTimer = nil;
}

- (void)stopAndPreparePlaying
{
    [self stopPlaying];
    
    [_player prepareToPlay];
}

- (void)deletePlaying
{
    [self stopPlaying];
    
    _blockAudioPlayingCallback = nil;
    _blockAudioFinishCallback = nil;

    _player = nil;
}


#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_blockAudioFinishCallback)
    {
        _blockAudioFinishCallback(self, flag);
    }
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if (_blockAudioPlayingCallback) {
        _blockAudioPlayingCallback(self, GAudioInterruptionBegin, nil);
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (_blockAudioPlayingCallback) {
        _blockAudioPlayingCallback(self, GAudioInterruptionEnd, nil);
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    if (_blockAudioPlayingCallback) {
        _blockAudioPlayingCallback(self, GAudioInterruptionEnd, nil);
    }
}

#pragma mark - Record
NSURL * GAudioRecordingFileURL(void)
{
    return [[GAudio sharedAudio] audioRecordingFileURL];
}

- (void)prepareRecordingWithCallback:(void (^)(GAudio *audio, GAudioInterruptionType type, NSError *error))callback
{
    self.blockAudioRecordingCallback = callback;
    
    NSError *error;
    _recorder =
    [[AVAudioRecorder alloc] initWithURL: self.audioRecordingFileURL
                                settings: @{ AVFormatIDKey: GNumberWithInt(kAudioFormatLinearPCM),
                                           AVSampleRateKey: GNumberWithFloat(8000.0),
                                     AVNumberOfChannelsKey: GNumberWithInt(1),
                                    AVLinearPCMBitDepthKey: GNumberWithInteger(16),
                                 AVLinearPCMIsBigEndianKey: GNumberWithBOOL(NO),
                                     AVLinearPCMIsFloatKey: GNumberWithBOOL(NO) }
                                   error: &error];
    
    //
    if (error) {
        //创建录音失败
        
        GPRINT(@"Error establishing recorder: %@", error.localizedFailureReason);
        if (_blockAudioRecordingCallback) {
            _blockAudioRecordingCallback(self, GAudioInterruptionNone, error);
        }
        
        [self deleteRecording];
    }else {
        //创建录音成功
        
        BOOL inputAvailable;
        if ([UIDevice isOSVersionHigherThanVersion:@"6.0" includeEqual:YES]) {
            inputAvailable = self.audioSession.inputAvailable;
        }else {
            inputAvailable = self.audioSession.inputIsAvailable;
        }
        if (!inputAvailable) {
            
            //无输入源
            
            GPRINT(@"Audio input hardware not available");
            NSError *error = [[NSError alloc] initWithDomain: @"GAudioRecordingError"
                                                        code: 0
                                                    userInfo: nil];
            if (_blockAudioRecordingCallback) {
                _blockAudioRecordingCallback(self, GAudioInterruptionNone, error);
            }
            
            [self deleteRecording];
            
        }else {
            
            //有录音源
            
            if (![_recorder prepareToRecord]) {
                
                //无法录音
                
                NSError *error = [[NSError alloc] initWithDomain: @"GAudioRecordingError"
                                                            code: 0
                                                        userInfo: nil];
                if (_blockAudioRecordingCallback) {
                    _blockAudioRecordingCallback(self, GAudioInterruptionNone, error);
                }
                
                [self deleteRecording];
            }
        }
    }
}

- (void)startRecording
{
    _recorder.delegate = self;
    
    if ([_recorder record]) {
        //开始录音并创建反馈
        if (_blockAudioRecordingCallback) {
            self.audioRecordingTimer =
            [CADisplayLink displayLinkWithTarget:self selector:@selector(audioRecordingTimerDidFire)];
            [_audioRecordingTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }else {
        //无法录音
    
        NSError *error = [[NSError alloc] initWithDomain: @"GAudioRecordingError"
                                                    code: 0
                                                userInfo: nil];
        if (_blockAudioRecordingCallback) {
            _blockAudioRecordingCallback(self, GAudioInterruptionNone, error);
        }
        
        [self deleteRecording];
    }
    
}

- (void)audioRecordingTimerDidFire
{
    if (_blockAudioRecordingCallback) {
        _blockAudioRecordingCallback(self, GAudioInterruptionNone, nil);
    }
}

- (void)pauseRecording
{
    [_recorder pause];
    
    [self.audioRecordingTimer invalidate];
    self.audioRecordingTimer = nil;
}
- (void)stopRecording
{
    [_recorder stop];
    _recorder.delegate = nil;
    
    [self.audioRecordingTimer invalidate];
    self.audioRecordingTimer = nil;
}
- (void)stopAndPrepareRecording
{
    [self stopRecording];
    
    [_recorder prepareToRecord];
}

- (BOOL)copyRecordedAudioFileToURL:(NSURL *)url
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtURL: url
                                                  error: &error];
        if (error) {
            GPRINTError(error);
            return NO;
        }
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtURL: self.audioRecordingFileURL
                                            toURL: url
                                            error: &error];
    if (error) {
        GPRINTError(error);
        return NO;
    }
    
    return YES;
}

- (void)deleteRecording
{
    [self stopRecording];
    
    [_recorder deleteRecording];
    _recorder = nil;
    
    _blockAudioRecordingCallback = nil;
}

//AVAudioRecorderDelegate
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    if (_blockAudioRecordingCallback) {
        _blockAudioRecordingCallback(self, GAudioInterruptionBegin, nil);
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    if (_blockAudioRecordingCallback) {
        _blockAudioRecordingCallback(self, GAudioInterruptionEnd, nil);
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
    if (_blockAudioRecordingCallback) {
        _blockAudioRecordingCallback(self, GAudioInterruptionEnd, nil);
    }
}

@end
