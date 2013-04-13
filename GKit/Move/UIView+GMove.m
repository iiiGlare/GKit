//
//  UIView+GMove.m
//  FreeMove
//
//  Created by Glare on 13-4-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "UIView+GMove.h"
#import "GMoveSpriteProtocol.h"
#import "GCore.h"

@implementation UIView (GMove)

- (UIView *)findSpriteAtPoint:(CGPoint)point
{
    //Check if self contains the location
    if (CGRectContainsPoint(self.bounds, point)) {
        
        //Check subviews, from the most top one.
        for (int i = [self.subviews count]-1; i>=0; i--) {
            UIView *subview = [self.subviews objectAtPosition:i];
            UIView *movedView = [subview findSpriteAtPoint:[self convertPoint:point toView:subview]];
            if (movedView) {
                return movedView;
            }
        }
        
        //Check self
        //We get it when self should move
        if ([self conformsToProtocol:GMoveSpriteProtocol()] &&
            [self respondsToSelector:@selector(canMove)] &&
            [(id<GMoveSpriteProtocol>)self canMove])
        {
            return self;
        }
    }
    
    return nil;

}

@end
