//
//  GView.m
//  GKitDemo
//
//  Created by Glare on 13-3-31.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GView.h"
#import "GCore.h"

@implementation GView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // top view
        _topView = [[UIView alloc] initWithFrame:self.bounds];
        [_topView setHeight:0];
        [_topView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_topView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_topView];
        
        // content view
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [_contentView setAutoresizingMask:GViewAutoresizingFlexibleSize];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        
        // bottom view
        _bottomView = [[UIView alloc] initWithFrame:self.bounds];
        [_bottomView setHeight:0];
        [_bottomView setOrigin:CGPointMake(0, self.bounds.size.height)];
        [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
        [_bottomView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_bottomView];
        
    }
    return self;
}

#pragma mark - Layout

- (void)setTopViewHeight:(CGFloat)topViewHeight
{
    CGFloat maxHeight = CGRectGetHeight(self.bounds) - CGRectGetHeight(_bottomView.frame);
    [_topView setHeight:MIN(MAX(0, topViewHeight), maxHeight)];
    [_contentView setOrigin:CGPointMake(0, CGRectGetMaxY(_topView.frame))];
    [_contentView setHeight:maxHeight-CGRectGetHeight(_topView.frame)];
}
- (void)setContentViewHeight:(CGFloat)contentViewHeight
{
    CGFloat maxHeight = CGRectGetHeight(self.bounds) - CGRectGetHeight(_bottomView.frame);
    [_contentView setHeight:MIN(MAX(0, contentViewHeight), maxHeight)];
    [_bottomView setOrigin:CGPointMake(0, CGRectGetMaxY(_contentView.frame))];
    [_bottomView setHeight:maxHeight-CGRectGetHeight(_contentView.frame)];
}
- (void)setBottomViewHeight:(CGFloat)bottomViewHeight
{
    CGFloat maxHeight = CGRectGetHeight(self.bounds) - CGRectGetHeight(_topView.frame);
    [_bottomView setHeight:MIN(MAX(0, bottomViewHeight), maxHeight)];
    [_bottomView setOrigin:CGPointMake(0, CGRectGetHeight(self.bounds) - CGRectGetHeight(_bottomView.frame))];
    [_contentView setHeight:maxHeight - CGRectGetHeight(_bottomView.frame)];
}

@end
