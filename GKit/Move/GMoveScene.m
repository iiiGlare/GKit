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

@interface GMoveScene ()
@property (nonatomic, strong) GMoveSnapshot *currentSnapshot;
@property (nonatomic, weak) id sourceCatcher;
@property (nonatomic, weak) id currentCatcher;

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
                    [catcher respondsToSelector:@selector(prepareSnapshotForOwnSprite:)])
                {
                    snapshot = [catcher prepareSnapshotForOwnSprite:sprite];
                }
                
                if (snapshot == nil)
                {
                    snapshot = [[GMoveSnapshot alloc] initWithFrame:spriteFrameInSelf];
                    [snapshot addSubviewToFill:[sprite snapshot]];
                    [snapshot setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
                }
                
                snapshot.sprite = sprite;
                [snapshot setCenter:CGPointMake( CGRectGetMidX(spriteFrameInSelf),
                                                CGRectGetMidY(spriteFrameInSelf))];
                [self addSubview:snapshot];
                
                if (catcher &&
                    [catcher respondsToSelector:@selector(prepareFrameForSnapshot:)])
                {
                    [UIView animateWithDuration: 0.25
                                     animations: ^{
                                         snapshot.frame = [catcher prepareFrameForSnapshot:snapshot];
                                     }];
                }
                
                //after prepare, befor show, give the cather a chance to do something
                if (catcher &&
                    [catcher respondsToSelector:@selector(didPrepareSnapshot:)])
                {
                    [catcher didPrepareSnapshot:snapshot];
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
            
            if (catcher!=self.currentCatcher)
            {
                [self catcherEndCatching:self.currentCatcher];
                self.currentCatcher = catcher;
                [self catcherBeginCatching:catcher];
            }else {
                [self catcherIsCatching:catcher];
            }
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
            //
            if (catcher!=self.currentCatcher)
            {
                [self catcherEndCatching:self.currentCatcher];
            }
            
            //
            if (catcher!=_sourceCatcher) {
                [self catcherRemoveOwnSprite:_sourceCatcher];
            }
            
            [self catcherDidCatch:catcher];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            //
            if (_sourceCatcher!=self.currentCatcher)
            {
                [self catcherEndCatching:self.currentCatcher];
            }
            
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
    self.currentCatcher = nil;
}

- (void)cancelLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer setEnabled:NO];
    [gestureRecognizer setEnabled:YES];
}

#pragma mark - Delegate Mothods
- (void)catcherBeginCatching:(id<GMoveSpriteCatcherProtocol>)catcher
{
    if (catcher &&
        [catcher respondsToSelector:@selector(beginCatchingSnapshot:)])
    {
        [catcher performSelector:@selector(beginCatchingSnapshot:) withObject:_currentSnapshot];
    }

}
- (void)catcherIsCatching:(id<GMoveSpriteCatcherProtocol>)catcher
{
    if (catcher &&
        [catcher respondsToSelector:@selector(isCatchingSnapshot:)])
    {
        [catcher performSelector:@selector(isCatchingSnapshot:) withObject:_currentSnapshot];
    }
}
- (void)catcherEndCatching:(id<GMoveSpriteCatcherProtocol>)catcher
{
    if (catcher &&
        [catcher respondsToSelector:@selector(endCatchingSnapshot:)])
    {
        [catcher endCatchingSnapshot:_currentSnapshot];
    }
    
}
- (void)catcherDidCatch:(id<GMoveSpriteCatcherProtocol>)catcher
{
    if (catcher &&
        [catcher respondsToSelector:@selector(didCatchSnapshot:)])
    {
        [catcher didCatchSnapshot:_currentSnapshot];
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
- (void)catcherRemoveOwnSprite:(id<GMoveSpriteCatcherProtocol>)catcher
{
    if (catcher &&
        [catcher respondsToSelector:@selector(removeOwnSprite:)])
    {
        [catcher removeOwnSprite:_currentSnapshot.sprite];
    }    
}

@end
