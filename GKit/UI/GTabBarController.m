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
#import "GNavigationViewController.h"

@implementation GTabBarController

+ (id)newWithControllerNames:(NSArray *)names
{
	if ([names count]==0) {
		return nil;
	}
	NSMutableArray *controllers = [[NSMutableArray alloc] initWithCapacity:[names count]];
	for (NSInteger i=0; i<[names count]; i++) {

		NSString *name = [names objectAtIndex:i];
		GASSERT([name length]>0);
		
        NSString *ClassString = [NSString stringWithFormat:@"%@ViewController",name];
		Class ViewController = NSClassFromString(ClassString);
		GASSERT(ViewController!=NULL);
		UIViewController *viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
		
		NSString *title = [NSString stringWithFormat:@"%@Title",name];
		NSString *image = [NSString stringWithFormat:@"%@Image.png",name];
		
		[viewController setTitle:NSLocalizedString(title,@"")];
		[viewController.tabBarItem setImage:[UIImage imageNamed:image]];

		[controllers addObject:[[GNavigationViewController alloc] initWithRootViewController:viewController]];
	}
	
	GTabBarController *tabBarController = [[GTabBarController alloc] init];
	[tabBarController setViewControllers:controllers animated:NO];
	return tabBarController;
}

// Create a custom UIButton and add it to the center of our tab bar
- (void) addActionButtonWithTarget: (id)target
                            action: (SEL)action
{
    //
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [viewControllers insertObjectAtCenter:[[UIViewController alloc] init]];
    [self setViewControllers:viewControllers animated:NO];
    
    //
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAutoresizingMask:GViewAutoresizingFlexibleMargins];
    UIImage *buttonImage = [UIImage imageNamed:@"CenterTabBarItemImage.png"];
    UIImage *highlightImage = [UIImage imageNamed:@"CenterTabBarItemImage-Highlight.png"];
    [button setFrame:CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _actionButton = button;

    [self _layoutActionButton];
    
    [self addObserver:self
           forKeyPath:@"tabBar.frame"
              options:NSKeyValueObservingOptionNew
              context:NULL];
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

@end
