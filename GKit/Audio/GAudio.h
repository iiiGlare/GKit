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

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

enum {
	GAudioSessionCategoryAmbient = 0,		//3.0
	GAudioSessionCategorySoloAmbient,		//3.0
	GAudioSessionCategoryPlayback,			//3.0
	GAudioSessionCategoryRecord,			//3.0
	GAudioSessionCategoryPlayAndRecord,		//3.0
	GAudioSessionCategoryAudioProcessing,	//3.1
	GAudioSessionCategoryMultiRoute			//6.0
};
typedef NSInteger GAudioSessionCategory;

enum  {
    GAudioInterruptionNone,
    GAudioInterruptionBegin,
    GAudioInterruptionEnd
};
typedef NSInteger GAudioInterruptionType;

@interface GAudio : NSObject

//Vibrate && SystemSound
+ (void) vibrate;
+ (void) playSystemSoundForResource: (NSString *)resource
                      withExtension: (NSString *)extension;

//Audio Session
+ (void) activeAudioSession;
+ (void) deactiveAudioSession;

+ (void) setSessionProperty: (GAudioSessionCategory)category;
+ (void) overrideCategoryMixWithOthers: (BOOL)isOverride;
+ (void) overrideOtherMixableAudioShouldDuck: (BOOL)isOverride;
+ (void) overrideCategoryDefaultToSpeaker: (BOOL)isOverride;
+ (void) overrideAudioRouteToSpeaker: (BOOL)isOverride;

//+ (BOOL)isSilenced;

//Init
+ (GAudio *) sharedAudio;
+ (GAudio *) newAudio;

//Play
@property (nonatomic, strong, readonly) AVAudioPlayer * player;

- (void) preparePlayingWithContents: (id)audioContents
                           callback: (void (^)(GAudio *audio, GAudioInterruptionType type, NSError *error))callback
                             finish: (void (^)(GAudio *audio, BOOL successfully))finish;
- (void) startPlayingWithCurrentTime: (NSTimeInterval)currentTime;
- (void) pausePlaying;
- (void) stopPlaying;
- (void) stopAndPreparePlaying;
- (void) deletePlaying;

//Record
@property (nonatomic, strong, readonly) AVAudioRecorder * recorder;

NSURL * GAudioRecordingFileURL(void);
- (void) prepareRecordingWithCallback: (void (^)(GAudio *audio, GAudioInterruptionType type, NSError *error))callback;
- (void) startRecording;
- (void) pauseRecording;
- (void) stopRecording;
- (void) stopAndPrepareRecording;
- (BOOL) copyRecordedAudioFileToURL: (NSURL *)url;
- (void) deleteRecording;

@end
