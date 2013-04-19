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
@property (nonatomic, weak) id sourceCatcher;

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
                
                id<GMoveSpriteCatcherProtocol> catcher = [sprite findCatcher];
                self.sourceCatcher = catcher;
                
                //prepare snapshot to move
                GMoveSnapshot *snapshot = nil;
                if (catcher &&
                    [catcher respondsToSelector:@selector(prepareSnapshotForSprite:)])
                {
                    snapshot = [catcher performSelector: @selector(prepareSnapshotForSprite:)
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
                    [snapshot setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
                }
                snapshot.sprite = sprite;
                [snapshot setCenter:CGPointMake( CGRectGetMidX(spriteFrameInSelf),
                                                CGRectGetMidY(spriteFrameInSelf))];
                [self addSubview:snapshot];
                
                //after prepare, befor show, give the cather a chance to do something
                if (catcher &&
                    [catcher respondsToSelector:@selector(didPrepareSnapshot:)])
                {
                    [catcher performSelector: @selector(didPrepareSnapshot:)
                                  withObject: snapshot];
                }
                
                self.currentSnapshot = snapshot;
                [self addSubview:snapshot];
                
                _historyTouchPoint = touchPoint;
                _moveOffset = CGPointZero;
                
            }else{
                
                //clean first before cancel
                [self cleanCatcherAndSnapshot];
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
            id<GMoveSpriteCatcherProtocol> catcher = [topestView findCatcher];
            
            [self catcherIsCatching:catcher];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint touchPoint = [gestureRecognizer locationInView:self];
            _moveOffset = CGPointMake(touchPoint.x - _historyTouchPoint.x, touchPoint.y - _historyTouchPoint.y);
            _historyTouchPoint = touchPoint;
            [self moveSnapshot];
            
            //notice the topest sprite catcher to catch the sprite, is topest sprite catcher is nil, then notice source catcher.
            UIView *topestView = [self hitTest:touchPoint withEvent:nil];
            id<GMoveSpriteCatcherProtocol> catcher = [topestView findCatcher];
            if (catcher==nil) catcher = self.sourceCatcher;
            
            [self catcherDidCatch:catcher];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self catcherDidCatch:_sourceCatcher];
        }
            break;
        default:
        {
            [self cleanCatcherAndSnapshot];
        }
            break;
    }
}

- (void)moveSnapshot
{
    [_currentSnapshot frameAddPoint:_moveOffset];
}

- (void)cleanCatcherAndSnapshot
{
    [self.currentSnapshot removeFromSuperview];
    self.currentSnapshot = nil;
    self.sourceCatcher = nil;
}

- (void)cancelLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer setEnabled:NO];
    [gestureRecognizer setEnabled:YES];
}

#pragma mark - Delegate Mothods
- (void)catcherIsCatching:(id<GMoveSpriteCatcherProtocol>)catcher
{
    if (catcher &&
        [catcher respondsToSelector:@selector(isCatchingSnapshot:)])
    {
        [catcher performSelector:@selector(isCatchingSnapshot:) withObject:_currentSnapshot];
    }
}
- (void)catcherDidCatch:(id<GMoveSpriteCatcherProtocol>)catcher
{
    if (catcher &&
        [catcher respondsToSelector:@selector(didCatchSnapshot:)])
    {
        [catcher performSelector:@selector(didCatchSnapshot:) withObject:_currentSnapshot];
    }
    
    if (_currentSnapshot)
    {
        [UIView animateWithDuration: .1
                         animations: ^{
                             _currentSnapshot.alpha = 0;
                         }
                         completion: ^(BOOL finished){
                             [self cleanCatcherAndSnapshot];
                         }];
    }
}

@end
