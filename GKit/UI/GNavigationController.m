//
//  GNavigationController.m
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GNavigationController.h"
#import "GCore.h"

#pragma mark - GNavigationControllerConfigurator
@interface GNavigationControllerConfigurator : NSObject
@property (nonatomic) BOOL canDragBack;  //default NO
@property (nonatomic) GNavigationAnimationType navigationAnimationType; //default GNavigationAnimationTypNormal

- (void)setBackItemWithImage: (UIImage *)image
           hightlightedImage: (UIImage *)hightlightedImage
					   title: (NSString *)title
				  titleColor: (UIColor *)color
        titleHightlightColor: (UIColor *)hColor
            titleShadowColor: (UIColor *)shadowColor
           titleShadowOffset: (CGSize)shadowOffset
				   titleFont: (UIFont *)font
		   contentEdgeInsets: (UIEdgeInsets)contentEdgeInsets
			 backgroundImage: (UIImage *)backgroundImage
 backgroundHightlightedImage: (UIImage *)backgroundHightlightedImage;

@property (nonatomic)         BOOL useCustomBackItem;
@property (nonatomic, strong) UIImage   * backImage;
@property (nonatomic, strong) UIImage   * backHightlightedImage;
@property (nonatomic, strong) NSString  * backTitle;
@property (nonatomic, strong) UIColor   * backTitleColor;
@property (nonatomic, strong) UIColor   * backTitleHightlightColor;
@property (nonatomic, strong) UIColor   * backTitleShadowColor;
@property (nonatomic)         CGSize    backTitleShadowOffset;
@property (nonatomic, strong) UIFont    * backTitleFont;
@property (nonatomic)         UIEdgeInsets  contentEdgeInsets;
@property (nonatomic, strong) UIImage       * backBackgroundImage;
@property (nonatomic, strong) UIImage       * backBackgroundHightlightedImage;

@end
@implementation GNavigationControllerConfigurator
- (void)setBackItemWithImage: (UIImage *)image
           hightlightedImage: (UIImage *)hightlightedImage
					   title: (NSString *)title
				  titleColor: (UIColor *)color
        titleHightlightColor: (UIColor *)hColor
            titleShadowColor: (UIColor *)shadowColor
           titleShadowOffset: (CGSize)shadowOffset
				   titleFont: (UIFont *)font
		   contentEdgeInsets: (UIEdgeInsets)contentEdgeInsets
			 backgroundImage: (UIImage *)backgroundImage
 backgroundHightlightedImage: (UIImage *)backgroundHightlightedImage
{
	self.useCustomBackItem = YES;
	self.backImage = image;
    self.backHightlightedImage = hightlightedImage;
	self.backTitle = title;
	self.backTitleColor = color;
    self.backTitleHightlightColor = hColor;
    self.backTitleShadowColor = shadowColor;
    self.backTitleShadowOffset = shadowOffset;
	self.backTitleFont = font;
	self.contentEdgeInsets = contentEdgeInsets;
	self.backBackgroundImage = backgroundImage;
    self.backBackgroundHightlightedImage = backgroundHightlightedImage;
}

@end

#pragma mark - GNavigationController
@interface GNavigationController ()
{
    BOOL _shouldPopItem;
}

@property (nonatomic, weak) UIPanGestureRecognizer *dragGestureRecognizer;

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, strong) NSMutableArray *snapshots;

@property (nonatomic, strong) UIView *backgroundScene;
@property (nonatomic, strong) UIView *snapshotCover;

@property (nonatomic, strong) UIImageView *tempSnapshot;

@property (nonatomic, strong) GPoint *location;

@property (nonatomic, strong) GNavigationControllerConfigurator * privateConfigurator;

@end

@implementation GNavigationController
#pragma mark - GConfigurator
+ (id)configurator {
	static dispatch_once_t onceToken;
	static GNavigationControllerConfigurator * configurator;
	dispatch_once(&onceToken, ^{
		configurator = [GNavigationControllerConfigurator new];
		configurator.canDragBack = NO;
		configurator.navigationAnimationType = GNavigationAnimationTypeNormal;
		configurator.useCustomBackItem = NO;
	});
	return configurator;
}

- (void)setBackItemWithImage: (UIImage *)image
           hightlightedImage: (UIImage *)hightlightedImage
					   title: (NSString *)title
				  titleColor: (UIColor *)color
        titleHightlightColor: (UIColor *)hightlightedColor
            titleShadowColor: (UIColor *)shadowColor
           titleShadowOffset: (CGSize)shadowOffset
				   titleFont: (UIFont *)font
		   contentEdgeInsets: (UIEdgeInsets)contentEdgeInsets
			 backgroundImage: (UIImage *)backgroundImage
 backgroundHightlightedImage: (UIImage *)backgroundHightlightedImage {
    self.privateConfigurator = [GNavigationControllerConfigurator new];
    [self.privateConfigurator setBackItemWithImage:image hightlightedImage:hightlightedImage title:title titleColor:color titleHightlightColor:hightlightedColor titleShadowColor:shadowColor titleShadowOffset:shadowOffset titleFont:font contentEdgeInsets:contentEdgeInsets backgroundImage:backgroundImage backgroundHightlightedImage:backgroundHightlightedImage];
}

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
    _canDragBack = [[GNavigationController configurator] canDragBack];
    _navigationAnimationType = [[GNavigationController configurator] navigationAnimationType];
    
    _shouldPopItem = NO;
    _snapshots = [NSMutableArray array];
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.canDragBack = _canDragBack;
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

#pragma mark - Setter / Getter
- (void)setCanDragBack:(BOOL)canDragBack
{
	_canDragBack = canDragBack;

	if (_canDragBack) {
		if (self.dragGestureRecognizer==nil) {
			UIPanGestureRecognizer *panGR =
			[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
			[self.view addGestureRecognizer:panGR];
			self.dragGestureRecognizer = panGR;
		}
	} else {
		[self.view removeGestureRecognizer:self.dragGestureRecognizer];
	}
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
    if ([self.viewControllers count]>=1) {
		[_snapshots addObject:[self.container.view snapshotView]];
		
		//Custom Back Item
		GNavigationControllerConfigurator * configurator = self.privateConfigurator;
        if (configurator==nil) {
            configurator = [GNavigationController configurator];
        }
		if (configurator.useCustomBackItem)
		{
			UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			[backButton setImage:configurator.backImage forState:UIControlStateNormal];
			[backButton setImage:configurator.backHightlightedImage forState:UIControlStateHighlighted];
            
			if (configurator.backTitle) {
				[backButton setTitle:configurator.backTitle forState:UIControlStateNormal];
			}
            else{
				[backButton setTitle:viewController.title forState:UIControlStateNormal];
			}
			
			if (configurator.backTitleColor) {
				[backButton setTitleColor:configurator.backTitleColor forState:UIControlStateNormal];
			}
			
            if (configurator.backTitleHightlightColor) {
                [backButton setTitleColor:configurator.backTitleHightlightColor forState:UIControlStateHighlighted];
            }
            
            if (configurator.backTitleShadowColor) {
                [backButton setTitleShadowColor:configurator.backTitleShadowColor forState:UIControlStateNormal];
            }
            
            [backButton.titleLabel setShadowOffset:configurator.backTitleShadowOffset];
            
			if (configurator.backTitleFont) {
				[backButton.titleLabel setFont:configurator.backTitleFont];
			}
            else {
				[backButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
			}
			
			[backButton setContentEdgeInsets:configurator.contentEdgeInsets];
			[backButton setBackgroundImage:configurator.backBackgroundImage forState:UIControlStateNormal];
            [backButton setBackgroundImage:configurator.backBackgroundHightlightedImage forState:UIControlStateHighlighted];
			[backButton sizeToFit];
			[backButton setWidth:MIN(backButton.width, 70)];
			[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
			UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
			viewController.navigationItem.leftBarButtonItem = backItem;
		}
	}
	
	if ([self.viewControllers count]>=1 &&
        _navigationAnimationType == GNavigationAnimationTypeHide)
    {
        [self showViewController:viewController];
    }else {
        
        [super pushViewController:viewController animated:animated];
    }

}
- (void)goBack
{
	[self popViewControllerAnimated:YES];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	// notify poped view controller
	if ([[self.viewControllers lastObject] respondsToSelector:@selector(willPop)]) {
		[[self.viewControllers lastObject] performSelector:@selector(willPop)];
	}
	
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
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
	// notify poped view controller
	if ([[self.viewControllers lastObject] respondsToSelector:@selector(willPop)]) {
		[[self.viewControllers lastObject] performSelector:@selector(willPop)];
	}
	
    if ([self.viewControllers count]>1 &&
        _navigationAnimationType == GNavigationAnimationTypeHide) {
        [_snapshots removeObjectsInRange:NSMakeRange(1, [self.viewControllers count]-1)];
        UIViewController *preViewController = [self.viewControllers objectAtPosition:0];
        [self hideTopViewController];
        return @[preViewController];
    }else {
        _shouldPopItem = YES;
        [_snapshots removeAllObjects];
        return [super popToRootViewControllerAnimated:animated];
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
    
    self.tempSnapshot = [self.container.view snapshotView];
    [self.container.view addSubviewToFill:self.tempSnapshot];
    [self goBackToPreViewController];
}
- (void)prepareSceneAndSnapshot
{
    _backgroundScene = [[UIView alloc] initWithFrame:self.container.view.frame];
    _backgroundScene.backgroundColor = [UIColor blackColor];
    [[self.container.view superview] insertSubview:_backgroundScene belowSubview:self.container.view];
    
    
    [_backgroundScene addSubviewToFill:[_snapshots lastObject]];
    [(UIView *)[_snapshots lastObject] setTransform:CGAffineTransformMakeScale(0.95, 0.95)];
    
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
                         [(UIView *)[_snapshots lastObject] setTransform:CGAffineTransformIdentity];
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
                         [(UIView *)[_snapshots lastObject] setTransform:CGAffineTransformIdentity];
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
    [(UIView *)[_snapshots lastObject] setTransform:CGAffineTransformMakeScale(scale, scale)];
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

#pragma mark - Override UINavigationBarDelegate
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

#pragma mark - Custom Present/Dismiss Animation

- (void)presentViewController: (UIViewController *)viewControllerToPresent
					 animated: (BOOL)flag
				   completion: (void (^)(void))completion
{
	[[self visibleViewController] presentViewController: viewControllerToPresent
											   animated: flag
											 completion: completion];
}

- (void)dismissViewControllerAnimated: (BOOL)flag
						   completion: (void (^)(void))completion
{
	[[self visibleViewController] dismissViewControllerAnimated: flag
													 completion: completion];
}

@end
