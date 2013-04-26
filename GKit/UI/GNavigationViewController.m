//
//  GNavigationViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GNavigationViewController.h"
#import "GCore.h"

@interface GNavigationViewController ()
{
    BOOL _shouldPopItem;
}

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, strong) NSMutableArray *snapshots;

@property (nonatomic, strong) UIView *backgroundScene;
@property (nonatomic, strong) UIView *snapshotCover;

@property (nonatomic, strong) UIImageView *tempSnapshot;

@property (nonatomic, strong) GPoint *location;

@end

@implementation GNavigationViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customInitialize];
        
    }
    return self;
}
- (void)customInitialize
{
    _canDragBack = YES;
    _navigationAnimationType = GNavigationAnimationTypeHide;
    
    _shouldPopItem = NO;
    _snapshots = [NSMutableArray array];
    
    UIPanGestureRecognizer *panGR =
    [[UIPanGestureRecognizer alloc] initWithTarget: self
                                            action: @selector(handlePan:)];
    [self.view addGestureRecognizer:panGR];
}

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Override Super Push/Pop Methods

- (UIViewController *)container
{
    if (_container==nil) {
        if (self.tabBarController) {
            _container = self.tabBarController;
        }else {
            _container = self;
        }
    }
    
    return _container;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count]>=1 &&
        _navigationAnimationType == GNavigationAnimationTypeHide)
    {
        [_snapshots addObject:[self.container.view snapshot]];
        
        [self showViewController:viewController];
    }else {
        
        [super pushViewController:viewController animated:animated];
    }

}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([self.viewControllers count]>1 &&
        _navigationAnimationType == GNavigationAnimationTypeHide) {
        UIViewController *preViewController = [self.viewControllers objectAtPosition:-2];
        [self hideTopViewController];
        return preViewController;
    }else {
        _shouldPopItem = YES;
        [_snapshots removeLastObject];
        return [super popViewControllerAnimated:animated];
    }
}

#pragma mark - Custom Push/Pop Methods
- (void)showViewController:(UIViewController *)viewController
{
    [self prepareSceneAndSnapshot];
    
    [self goToNextViewController:viewController];
}
- (void)hideTopViewController
{
    [self prepareSceneAndSnapshot];
    
    self.tempSnapshot = [self.container.view snapshot];
    [self.container.view addSubviewToFill:self.tempSnapshot];
    [self goBackToPreViewController];
}
- (void)prepareSceneAndSnapshot
{
    _backgroundScene = [[UIView alloc] initWithFrame:self.container.view.frame];
    _backgroundScene.backgroundColor = [UIColor blackColor];
    [[self.container.view superview] insertSubview:_backgroundScene belowSubview:self.container.view];
    
    
    [_backgroundScene addSubviewToFill:[_snapshots lastObject]];
    [[_snapshots lastObject] setTransform:CGAffineTransformMakeScale(0.95, 0.95)];
    
    _snapshotCover = [[UIView alloc] initWithFrame:self.container.view.frame];
    _snapshotCover.backgroundColor = [UIColor blackColor];
    [_backgroundScene addSubviewToFill:_snapshotCover];
}

#pragma mark - Gesture Recognizer
- (void)handlePan:(UIPanGestureRecognizer *)panGR
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self prepareSceneAndSnapshot];
                        
            _location = [[GPoint alloc] init];
            _location.canMoveVertical = NO;
            _location.point = [panGR locationInView:_backgroundScene];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            _location.point = [panGR locationInView:_backgroundScene];
            [self moveViewAddOffset:_location.moveOffset];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.container.view.x-_backgroundScene.x>30) {
                [self goBackToPreViewController];
            }else {
                [self stayInCurrentViewController];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self stayInCurrentViewController];
        }
            break;
        default:
            break;
    }
        

}

#pragma mark - Show / Hide Animation
- (void)goToNextViewController:(UIViewController *)viewController
{
    CGPoint origin = _backgroundScene.origin;
    origin.x += _backgroundScene.width;
    [self moveViewToOrigin:origin];
    [super pushViewController:viewController animated:NO];
    
    [UIView animateWithDuration: 0.25
                     animations: ^{
                         [self moveViewToOrigin:_backgroundScene.origin];
                     }
                     completion:^(BOOL finished){
                         [[_snapshots lastObject] setTransform:CGAffineTransformIdentity];
                         [self cleanTemporaryData];
                     }];

}

- (void)goBackToPreViewController
{
    [UIView animateWithDuration: 0.25 * ((CGRectGetMaxX(_backgroundScene.frame)-self.container.view.x)/_backgroundScene.width)
                     animations: ^{
                         CGPoint origin = _backgroundScene.origin;
                         origin.x += _backgroundScene.width;
                         [self moveViewToOrigin:origin];
                     }
                     completion:^(BOOL finished){
                         [self moveViewToOrigin:_backgroundScene.origin];
                         _shouldPopItem = YES;
                         UIViewController *topViewController = [self topViewController];
                         if ([topViewController respondsToSelector:@selector(tableView)]) {
                             UITableView *tableView = [topViewController performSelector:@selector(tableView)];
                             tableView.delegate = nil;
                         }
                         [super popViewControllerAnimated:NO];
                         [_snapshots removeLastObject];
                         [self cleanTemporaryData];
                     }];
}
- (void)stayInCurrentViewController
{
    [UIView animateWithDuration: 0.1
                     animations: ^{
                         [self moveViewToOrigin:_backgroundScene.origin];
                     }
                     completion:^(BOOL finished){
                         [[_snapshots lastObject] setTransform:CGAffineTransformIdentity];
                         [self cleanTemporaryData];
                     }];
}

- (void)moveViewAddOffset:(CGPoint)offset
{
    CGPoint origin = self.container.view.origin;
    origin.x += offset.x;
    origin.y += offset.y;
    [self moveViewToOrigin:origin];
}

- (void)moveViewToOrigin:(CGPoint)origin
{
    origin.x = MAX(_backgroundScene.x, origin.x);
    [self.container.view setOrigin:origin];
    
    CGFloat factor = MIN(1.0, MAX(0, (origin.x-_backgroundScene.x)/[_backgroundScene width]));
    CGFloat scale = 0.95 + 0.05 * factor;
    [[_snapshots lastObject] setTransform:CGAffineTransformMakeScale(scale, scale)];
    _snapshotCover.alpha = 0.5 * (1.0-factor);
}

- (void)cleanTemporaryData
{
    [self.backgroundScene removeFromSuperview];
    self.backgroundScene = nil;
    
    [self.tempSnapshot removeFromSuperview];
    self.tempSnapshot = nil;
    
    [self.snapshotCover removeFromSuperview];
    self.snapshotCover = nil;
    
    self.location = nil;
}

#pragma mark - 
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    
    //_shouldPopItem is always NO, to make sure the navigationBar's delegate will not automatically manage pop stuff.
    
    if (_shouldPopItem) {
        
        _shouldPopItem = NO;
        return YES;
        
    }else{
        
        if (_navigationAnimationType == GNavigationAnimationTypeHide) {
            [self hideTopViewController];
        }else {
            [self popViewControllerAnimated:YES];
        }
        
        return NO;
    }
}


@end
