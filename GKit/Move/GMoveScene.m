//
//  GMoveScene.m
//  FreeMove
//
//  Created by Glare on 13-4-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GMoveScene.h"
#import "GMoveSnapshot.h"
#import "GMoveSpriteProtocol.h"
#import "GMoveSpriteCatcherProtocol.h"
#import "UIView+GMove.h"
#import "GCore.h"
#import <QuartzCore/QuartzCore.h>

@interface GMoveScene ()
@property (nonatomic, strong) GMoveSnapshot *currentSnapshot;

@property (nonatomic, assign) CGPoint historyTouchPoint;
@property (nonatomic, assign) CGPoint moveOffset;

@end

@implementation GMoveScene

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPressGR];
    }
    return self;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint touchPoint = [gestureRecognizer locationInView:self];
            
            UIView *sprite = [self findSpriteAtPoint:touchPoint];
            if (sprite) {
                
                CGRect spriteFrameInSelf = [self convertRect:sprite.frame fromView:sprite.superview];
                
                UIViewController *controller = [sprite viewController];
                
                //prepare snapshot to move
                GMoveSnapshot *snapshot = nil;
                if ([controller conformsToProtocol:GMoveSpriteCatcherProtocol()] &&
                    [controller respondsToSelector:@selector(prepareSnapshotForSprite:)])
                {
                    snapshot = [controller performSelector: @selector(prepareSnapshotForSprite:)
                                                withObject: sprite];
                }
                if (snapshot == nil) {
                    
                    UIGraphicsBeginImageContextWithOptions(sprite.frame.size, NO, GScreenScale);
                    [[sprite layer] renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIImageView *snapshotImageView = [[UIImageView alloc] initWithImage:snapshotImage];
                    UIGraphicsEndImageContext();
                    
                    snapshot = [[GMoveSnapshot alloc] initWithFrame:spriteFrameInSelf];
                    [snapshot addSubviewToFill:snapshotImageView];
                    [snapshot setAlpha:0.5];
                }
                snapshot.sprite = sprite;
                [snapshot setCenter:CGPointMake( CGRectGetMidX(spriteFrameInSelf),
                                                 CGRectGetMidY(spriteFrameInSelf))];
                [self addSubview:snapshot];
                
                //after prepare, befor show, give the cather a chance to do something
                if ([controller conformsToProtocol:GMoveSpriteCatcherProtocol()] &&
                    [controller respondsToSelector:@selector(didPrepareSnapshotForSprite:)])
                {
                    [controller performSelector: @selector(didPrepareSnapshotForSprite:)
                                     withObject: sprite];
                }
                
                self.currentSnapshot = snapshot;
                [self addSubview:snapshot];
                
                _historyTouchPoint = touchPoint;
                _moveOffset = CGPointZero;
                
            }else{
                
                [self cleanSnapshot];
                [self cancelLongPress:gestureRecognizer];
                
                return;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint touchPoint = [gestureRecognizer locationInView:self];
            _moveOffset = CGPointMake(touchPoint.x - _historyTouchPoint.x, touchPoint.y - _historyTouchPoint.y);
            _historyTouchPoint = touchPoint;
            [self moveSnapshot];
            
            //notice the topest sprite catcher to catching the sprite's movement
            UIView *topestView = [self hitTest:touchPoint withEvent:nil];
            if (topestView) {
                UIViewController *controller = [topestView viewController];
                if (controller &&
                    [controller conformsToProtocol:GMoveSpriteCatcherProtocol()] &&
                    [controller respondsToSelector:@selector(isCatchingSnapshot:)])
                {
                    [controller performSelector:@selector(isCatchingSnapshot:) withObject:_currentSnapshot];
                }
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint touchPoint = [gestureRecognizer locationInView:self];
            _moveOffset = CGPointMake(touchPoint.x - _historyTouchPoint.x, touchPoint.y - _historyTouchPoint.y);
            _historyTouchPoint = touchPoint;
            [self moveSnapshot];

            
            //notice the topest sprite catcher to catch the sprite
            UIView *topestView = [self hitTest:touchPoint withEvent:nil];
            if (topestView) {
                UIViewController *controller = [topestView viewController];
                if (controller &&
                    [controller conformsToProtocol:GMoveSpriteCatcherProtocol()] &&
                    [controller respondsToSelector:@selector(didCatchSnapshot:)])
                {
                    [controller performSelector:@selector(didCatchSnapshot:) withObject:_currentSnapshot];
                }
            }

            [UIView animateWithDuration: .1
                             animations: ^{
                                _currentSnapshot.alpha = 0;
                             }
                             completion: ^(BOOL finished){
                                 [self cleanSnapshot];
                             }];
        }
            break;
        default:
        {
            [self cleanSnapshot];
        }
            break;
    }
}

- (void)moveSnapshot
{
    [_currentSnapshot frameAddPoint:_moveOffset];
}

- (void)cleanSnapshot
{
    [self.currentSnapshot removeFromSuperview];
    self.currentSnapshot = nil;
}

- (void)cancelLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer setEnabled:NO];
    [gestureRecognizer setEnabled:YES];
}

@end
