//
//  GNavigationViewController.h
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    GNavigationAnimationTypNormal,
    GNavigationAnimationTypeHide
};
typedef NSInteger GNavigationAnimationType;

@interface GNavigationViewController : UINavigationController

@property (nonatomic) BOOL canDragBack;  //default YES
@property (nonatomic) GNavigationAnimationType navigationAnimationType; //default hide

@end
