//
//  GMusicPlayer.m
//  jige
//
//  Created by 华 曹 on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GMusicPlayer.h"

@implementation GMusicPlayer

- (id)initWithMPMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection {
	self = [super init];
	if (self) {
		[self _setupMusicPlayerControllerWithCollection:mediaItemCollection];
	}
	return self;
}

- (void)_setupMusicPlayerControllerWithCollection:(MPMediaItemCollection *)mediaItemCollection {
	_musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
	[_musicPlayerController setShuffleMode:MPMusicShuffleModeOff];
	[_musicPlayerController setRepeatMode:MPMusicRepeatModeAll];
	[_musicPlayerController setQueueWithItemCollection:mediaItemCollection];	
}

#pragma mark - Control
- (void)play {
	[_musicPlayerController play];
}
- (void)stop {
	[_musicPlayerController stop];
}
@end
