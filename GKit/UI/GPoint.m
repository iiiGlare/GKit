//
//  GPoint.m
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GPoint.h"

@interface GPoint ()
@property (nonatomic, assign) CGPoint historyPoint;
@end

@implementation GPoint
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
        _canMoveHorizontal = YES;
        _canMoveVertical = YES;
    }
    return self;
}

#pragma mark - Getter / Setter
- (void)setPoint:(CGPoint)point
{
    _historyPoint = _point;
    _point = point;
}

- (void)setX:(CGFloat)x
{
    _historyPoint.x = _point.x;
    _point.x = x;
}

- (void)setY:(CGFloat)y
{
    _historyPoint.y = _point.y;
    _point.y = y;
}

- (CGPoint)moveOffset
{
    CGPoint moveOffset = CGPointMake(_point.x-_historyPoint.x,
                                     _point.y-_historyPoint.y);
    if (!_canMoveHorizontal) moveOffset.x = 0;
    if (!_canMoveVertical) moveOffset.y = 0;
    
    return moveOffset;
}

@end
