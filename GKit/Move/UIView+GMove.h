//
//  UIView+GMove.h
//  FreeMove
//
//  Created by Glare on 13-4-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMoveSpriteCatcherProtocol.h"

@interface UIView (GMove)

- (UIView *) findSpriteAtPoint:(CGPoint)point;
- (id<GMoveSpriteCatcherProtocol>) findCatcher;

@end
