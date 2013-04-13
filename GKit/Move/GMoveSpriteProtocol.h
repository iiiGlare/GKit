//
//  GMoveSpriteProtocol.h
//  FreeMove
//
//  Created by Glare on 13-4-13.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

/*
 Wanna a View movetable, it should conform to GMoveSpriteProtocol,
 */

#define GMoveSpriteProtocol() NSProtocolFromString(@"GMoveSpriteProtocol")

@protocol GMoveSpriteProtocol <NSObject>

- (BOOL)canMove;

@end
