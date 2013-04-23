//
//  GNavigationViewController.h
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (GNavigationViewController)

- (void)showViewController:(UIViewController *)viewController;
- (void)hideTopViewController;

@end

@interface GNavigationViewController : UINavigationController

@property (nonatomic,assign) BOOL canDragBack;

@end
