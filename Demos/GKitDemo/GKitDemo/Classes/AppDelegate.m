//
//  AppDelegate.m
//  GKitDemo
//
//  Created by Glare on 13-2-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "AppDelegate.h"
#import "GCore.h"
#import "GNavigationController.h"
#import "GTabBarController.h"
#import "DemosViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [GCoreData setupWithName:@"GKitDemo"];
//    
//	NSManagedObjectContext *newContext = [GCoreData newContext];
//	for (int i=0;i<10;i++) {
//		for (int j=0; j<10; j++) {
//			Task *task = [GCoreData findFirstForEntityName: @"Task"
//											 withPredicate: [NSPredicate predicateWithFormat:@"type=%@ AND title=%@",
//															 [NSString stringWithFormat:@"%d",i],
//															 [NSString stringWithFormat:@"%d-%d",i,j]]
//												 inContext: newContext];
//			if (task==nil) {
//				task = [GCoreData insertNewForEntityNamed: @"Task"
//												inContext: newContext];
//				task.type = [NSString stringWithFormat:@"%d",i];
//				task.title = [NSString stringWithFormat:@"%d-%d",i,j];
//				[GCoreData saveObject:task];
//			}
//		}
//	}
	
	[[GViewController configurator] setPresentAnimationType:GPresentAnimationTypeHide];
	
	[GNavigationGlobalConfigurator setNavigationAnimationType:GNavigationAnimationTypNormal];
	[GNavigationGlobalConfigurator setCanDragBack:NO];
	[GNavigationGlobalConfigurator setBackItemWithImage: nil
												  title: @"Back"
											 titleColor: [UIColor whiteColor]
                                   titleHightlightColor: [UIColor grayColor]
                                       titleShadowColor: [UIColor whiteColor]
                                      titleShadowOffset: CGSizeMake(0, 1)
											  titleFont: [UIFont systemFontOfSize:12.0]
									  contentEdgeInsets: UIEdgeInsetsMake(0, 8, 0, 2)
										backgroundImage: [[UIImage imageNamed:@"back_item_backgournd"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 10)]];
	
    self.window = [[UIWindow alloc] initWithFrame:GScreenBounds()];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

	self.window.rootViewController = [GTabBarController newWithControllerNames:@[@"Demos",@"Demos"]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)centerTabBarItemSelected
{
    GPRINT(@"CenterTabBarItemSelected");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
