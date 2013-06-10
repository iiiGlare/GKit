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

#pragma mark - GNavigationViewControllerInfo
@interface GNavigationGlobalConfigurator : NSObject

+ (void)setCanDragBack:(BOOL)canDragBack;
+ (void)setNavigationAnimationType:(GNavigationAnimationType)navigationAnimationType;
+ (void)setBackItemWithImage: (UIImage *)image
					   title: (NSString *)title
				  titleColor: (UIColor *)color
        titleHightlightColor: (UIColor *)hColor
				   titleFont: (UIFont *)font
		   contentEdgeInsets: (UIEdgeInsets)contentEdgeInsets
			 backgroundImage: (UIImage *)backgroundImage;

@end

#pragma mark - GNavigationViewController
@interface GNavigationViewController : UINavigationController

@property (nonatomic) BOOL canDragBack;  //default YES
@property (nonatomic) GNavigationAnimationType navigationAnimationType; //default hide

@end