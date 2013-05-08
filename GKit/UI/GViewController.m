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

@interface GViewController ()

//for present / dismiss animation
@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, weak) UIView *presentedView;
@property (nonatomic, strong) UIView *backgroundScene;
@property (nonatomic, strong) UIImageView *snapshot;
@property (nonatomic, strong) UIView *snapshotCover;

@end

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
    _canDragDismiss = YES;
    _presentAnimationType = GPresentAnimationTypeHide;
};

#pragma mark - View Life Cycle

- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
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

#pragma mark - Custom Present/Dismiss Animation
- (UIViewController *)container
{
    if (_container==nil) {
        //
        if (self.tabBarController) {
            _container = self.tabBarController;
        }else if (self.navigationController) {
            _container = self.navigationController;
        }else if (self.parentViewController) {
            _container = self.parentViewController;
        }else {
            _container = self;
        }
    }
    return _container;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    
    self.snapshot = [self.container.view snapshot];
    
    [super presentViewController: viewControllerToPresent
                        animated: NO
                      completion: nil];
    
    self.presentedView = viewControllerToPresent.view;
    [self prepareSceneAndSnapshot];

    CGPoint beginOrigin = viewControllerToPresent.view.origin;
    CGPoint endOrigin = beginOrigin;
    endOrigin.y += viewControllerToPresent.view.height;
    [self moveViewToOrigin:endOrigin];
    [UIView animateWithDuration: 0.25
                     animations: ^{
                         [self moveViewToOrigin:beginOrigin];
                     }
                     completion:^(BOOL finished){
                         [self.snapshot setTransform:CGAffineTransformIdentity];
                         [self cleanTemporaryData];
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{

    if (self.snapshot==nil) {
        self.presentedView = [[self.presentingViewController presentedViewController] view];
        self.snapshot = [[self.presentingViewController view] snapshot];
    }
    
    [self prepareSceneAndSnapshot];
    
    CGPoint beginOrigin = self.presentedView.origin;
    CGPoint endOrigin = beginOrigin;
    endOrigin.y += self.presentedView.height;
    
    [UIView animateWithDuration: 0.25
                     animations: ^{
                         [self moveViewToOrigin:endOrigin];
                     }
                     completion: ^(BOOL finished){
                         [super dismissViewControllerAnimated:NO completion:nil];
                         [self.snapshot removeFromSuperview];
                         self.snapshot = nil;
                         [self cleanTemporaryData];
                         if (completion) {
                             completion();
                         }
                     }];
}
- (void)prepareSceneAndSnapshot
{
    _backgroundScene = [[UIView alloc] initWithFrame:self.presentedView.superview.bounds];
    _backgroundScene.backgroundColor = [UIColor blackColor];
    [self.presentedView.superview insertSubview: _backgroundScene
                                   belowSubview: self.presentedView];
    
    
    [_backgroundScene addSubviewToFill:self.snapshot];
    [self.snapshot setTransform:CGAffineTransformMakeScale(0.95, 0.95)];
    
    _snapshotCover = [[UIView alloc] initWithFrame:CGRectZero];
    _snapshotCover.backgroundColor = [UIColor blackColor];
    [_backgroundScene addSubviewToFill:_snapshotCover];
}

- (void)moveViewToOrigin:(CGPoint)origin
{
    origin.y = MAX(_backgroundScene.y, origin.y);
    [self.presentedView setOrigin:origin];
    
    CGFloat factor = MIN(1.0, MAX(0, (origin.y-_backgroundScene.y)/[_backgroundScene height]));
    CGFloat scale = 0.95 + 0.05 * factor;
    [self.snapshot setTransform:CGAffineTransformMakeScale(scale, scale)];
    _snapshotCover.alpha = 0.5 * (1.0-factor);
}

- (void)cleanTemporaryData
{
    [self.backgroundScene removeFromSuperview];
    self.backgroundScene = nil;
        
    [self.snapshotCover removeFromSuperview];
    self.snapshotCover = nil;
}

@end
