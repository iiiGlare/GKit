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

enum{
	AudioSessionCategoryAmbient = 0,		//3.0
	AudioSessionCategorySoloAmbient,		//3.0
	AudioSessionCategoryPlayback,			//3.0
	AudioSessionCategoryRecord,				//3.0
	AudioSessionCategoryPlayAndRecord,		//3.0
	AudioSessionCategoryAudioProcessing,	//3.1
	AudioSessionCategoryMultiRoute			//6.0
};
typedef NSInteger AudioSessionCategory;


@interface GAudio : NSObject

//play
+ (void)vibrate;
+ (void)playSystemSoundForResource:(NSString *)resource
					 withExtension:(NSString *)extension;
+ (void)playAudioWithContentsOfURL:(NSURL *)fileURL
							volume:(CGFloat)volume
                        completion:(void (^)(void))completion;
+ (void)stopPlayAudio;

//record
NSURL * GAudioRecordingFileURL(void);
+ (void)prepareRecordingWithCallback:(void (^)(NSTimeInterval currentTime, BOOL recording, BOOL interruption, NSError *error))callback;
+ (void)startRecording;
+ (void)pauseRecording;
+ (void)stopRecording;
+ (void)copyRecordedAudioFileToURL:(NSURL *)url;
+ (void)deleteRecording;


//audio session
+ (void)activeAudioSession;
+ (void)deactiveAudioSession;
+ (void)setSessionProperty:(AudioSessionCategory)category;
+ (void)overrideCategoryDefaultToSpeaker:(BOOL)isOverride;
+ (void)overrideAudioRouteToSpeaker:(BOOL)isOverride;
+ (BOOL)isSilenced;

@end
