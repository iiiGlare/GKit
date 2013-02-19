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

static GAudio *_sharedAudio = nil;

@interface GAudio ()
<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioSession *audioSession;
+ (void)initSharedAudio;
+ (void)initSharedAudioSession;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
- (void)playMusicWithContentsOfURL:(NSURL *)fileURL volume:(CGFloat)volume;



@end

@implementation GAudio
@synthesize audioPlayer;
@synthesize audioSession = _audioSession;

+ (void)initSharedAudio
{
	if (_sharedAudio==nil) {
		_sharedAudio = [[GAudio alloc] init];
	}
}

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
	[self initSharedAudio];
	[_sharedAudio playMusicWithContentsOfURL:fileURL volume:volume];
}

- (void)playMusicWithContentsOfURL:(NSURL *)fileURL volume:(CGFloat)volume
{
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
																	  error:nil];
	newPlayer.volume = volume;
	newPlayer.delegate = self;
	[newPlayer prepareToPlay];
	[newPlayer setCurrentTime:0];
	[newPlayer play];
	self.audioPlayer = newPlayer;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	self.audioPlayer = nil;
}

#pragma mark - AVAudioSession
+ (void)initSharedAudioSession
{
	[self initSharedAudio];
	//init session
	if (_sharedAudio.audioSession==nil) {
		_sharedAudio.audioSession = [AVAudioSession sharedInstance];
	}
}

+ (void)activeAudioSession
{
	//activating
	NSError *activationError = nil;
	[_sharedAudio.audioSession setActive:YES error:&activationError];
}
+ (void)deactiveAudioSession
{
	//activating
	NSError *activationError = nil;
	[_sharedAudio.audioSession setActive:NO error:&activationError];
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
		[GAudio initSharedAudioSession];
		
		if ([_sharedAudio.audioSession.category isEqualToString:theCategory]) {
			return;
		}
		
		[GAudio deactiveAudioSession];
		//setting the category
		NSError *setCategoryError = nil;
		[_sharedAudio.audioSession setCategory:theCategory error:&setCategoryError];
		[GAudio activeAudioSession];
	}
}
+ (void)overrideCategoryDefaultToSpeaker:(BOOL)isOverride
{
	[GAudio initSharedAudioSession];
	
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
	[GAudio initSharedAudioSession];
	
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
	
	[GAudio initSharedAudioSession];
	
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
