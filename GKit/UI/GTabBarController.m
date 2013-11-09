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

#import "GTabBarController.h"
#import "GCore.h"
#import "GNavigationController.h"

@interface GTabBarController ()

@property (nonatomic, strong) UIButton * actionButton;
@property (nonatomic, copy) void (^actionButtonEventHandler)(id sender);

@end

@implementation GTabBarController

+ (G_INSTANCETYPE)newWithViewControllers:(NSArray *)viewControllers {
    GTabBarController * tabBarController = [GTabBarController new];
    [tabBarController setViewControllers:viewControllers animated:NO];
    return tabBarController;
}

+ (G_INSTANCETYPE)newWithViewControllerNames:(NSArray *)viewControllerNames
                                      titles:(NSArray *)titles
                                      images:(NSArray *)images
                              needNavigation:(BOOL)needNavigation {
    NSMutableArray * controllers = [[NSMutableArray alloc] initWithCapacity:[viewControllerNames count]];
	for (NSInteger i=0; i<[viewControllerNames count]; i++) {
        //
		NSString * className = [viewControllerNames objectAtPosition:i];
		UIViewController * viewController = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
		//
        NSString * title = [titles objectAtPosition:i];
        if ([title isKindOfClass:[NSString class]]) {
            [viewController setTitle:GLocalizedString(title)];
        }
        else {
            [viewController setTitle:nil];
        }
		//
        id image = [images objectAtPosition:i];
        if ([image isKindOfClass:[NSString class]]) {
            [viewController.tabBarItem setImage:GImageNamed(image)];
        }
        else if ([image isKindOfClass:[UIImage class]]) {
            [viewController.tabBarItem setImage:image];
        }
        else {
            [viewController.tabBarItem setImage:nil];
        }
        
        //
        if (needNavigation) {
            [controllers addObject:[GNavigationController newWithRootViewController:viewController]];
        }
        else {
            [controllers addObject:viewController];
        }
	}
    
    return [GTabBarController newWithViewControllers:controllers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    if (_actionButton) {
        [self.view addSubview:_actionButton];
        [self _layoutActionButton];
    }
}

// Create a custom UIButton and add it to the center of our tab bar
- (UIButton *)addActionButtonWithSize:(CGSize)size
                         eventHandler:(void (^)(id sender))eventHandler
                     forControlEvents:(UIControlEvents)controlEvents {
    //
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [viewControllers insertObjectAtCenter:[UIViewController new]];
    [self setViewControllers:viewControllers animated:NO];
    
    //
    self.actionButtonEventHandler = eventHandler;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = size;
    button.autoresizingMask = GViewAutoresizingFlexibleMargins;
    [button addTarget:self action:@selector(_handleActionButtonEvents) forControlEvents:controlEvents];
    
    [self.view addSubview:button];
    self.actionButton = button;
    [self _layoutActionButton];
    
    //
    [self addObserver:self
           forKeyPath:@"tabBar.frame"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    return _actionButton;
}

- (void)_handleActionButtonEvents {
    if (_actionButtonEventHandler) {
        _actionButtonEventHandler(_actionButton);
    }
}

- (void)_layoutActionButton
{
    CGFloat heightDifference = _actionButton.frame.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        _actionButton.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        _actionButton.center = center;
    }
}

#pragma mark - KeyValueObserve
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"tabBar.frame"]) {
        [self _layoutActionButton];
    }
}

#pragma mark - Custom Present/Dismiss Animation

- (void)presentViewController: (UIViewController *)viewControllerToPresent
					 animated: (BOOL)flag
				   completion: (void (^)(void))completion
{
	[[self selectedViewController] presentViewController: viewControllerToPresent
												animated: flag
											  completion: completion];
}

- (void)dismissViewControllerAnimated: (BOOL)flag
						   completion: (void (^)(void))completion
{
	[[self selectedViewController] dismissViewControllerAnimated: flag
													  completion: completion];
}	

@end
