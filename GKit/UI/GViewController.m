//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
#import "GViewController.h"
#import "GCore.h"

@implementation GViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customInitialize];
    }
    return self;
}

- (void)customInitialize
{

};

#pragma mark - View Life Cycle

- (void)loadView
{
    [super loadView];
    
    [self.view setAutoresizingMask:GViewAutoresizingFlexibleSize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     Setup Top/Content/Bottom View
     */
    CGFloat topViewHeight = 0;
    CGFloat bottomViewHeight = 0;
    
    //top view
    if (self.topView==nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
    }else{
        topViewHeight = [_topView height];
    }
    _topView.backgroundColor = [UIColor clearColor];
    _topView.frame = CGRectMake(0, 0, [self.view width], 0);
    [_topView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_topView];
    
    //conten view
    if (self.contentView==nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.frame = self.view.bounds;
    [_contentView setAutoresizingMask:GViewAutoresizingFlexibleSize];
    [self.view insertSubview:_contentView belowSubview:_topView];

    //bottom view
    if (self.bottomView==nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    }else {
        bottomViewHeight = [_bottomView height];
    }
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomView.frame = CGRectMake(0, [self.view height], [self.view width], 0);
    [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_bottomView];
    
    
    [self setTopViewHeight:topViewHeight];
    [self setBottomViewHeight:bottomViewHeight];
}

- (void)setTopViewHeight:(CGFloat)topViewHeight
{
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_bottomView.frame);
    [_topView setHeight:MIN(MAX(0, topViewHeight), maxHeight)];
    [_contentView setOrigin:CGPointMake(0, CGRectGetMaxY(_topView.frame))];
    [_contentView setHeight:maxHeight-CGRectGetHeight(_topView.frame)];
}
- (void)setContentViewHeight:(CGFloat)contentViewHeight
{
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_bottomView.frame);
    [_contentView setHeight:MIN(MAX(0, contentViewHeight), maxHeight)];
    [_bottomView setOrigin:CGPointMake(0, CGRectGetMaxY(_contentView.frame))];
    [_bottomView setHeight:maxHeight-CGRectGetHeight(_contentView.frame)];
}
- (void)setBottomViewHeight:(CGFloat)bottomViewHeight
{
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_topView.frame);
    [_bottomView setHeight:MIN(MAX(0, bottomViewHeight), maxHeight)];
    [_bottomView setOrigin:CGPointMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_bottomView.frame))];
    [_contentView setHeight:maxHeight - CGRectGetHeight(_bottomView.frame)];
}

@end
