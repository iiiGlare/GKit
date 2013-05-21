//
//  GMusicPlayer.h
//  jige
//
//  Created by 华 曹 on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GMusicPlayer : NSObject

@property (nonatomic, strong) MPMusicPlayerController *musicPlayerController;

- (id)initWithMPMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection;
- (void)play;
- (void)stop;

@end
