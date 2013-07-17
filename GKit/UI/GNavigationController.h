//
//  GNavigationController.h
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

#pragma mark - GNavigationControllerInfo
@interface GNavigationGlobalConfigurator : NSObject

+ (void)setCanDragBack:(BOOL)canDragBack;
+ (void)setNavigationAnimationType:(GNavigationAnimationType)navigationAnimationType;
+ (void)setBackItemWithImage: (UIImage *)image
					   title: (NSString *)title
				  titleColor: (UIColor *)color
        titleHightlightColor: (UIColor *)hColor
            titleShadowColor: (UIColor *)shadowColor
           titleShadowOffset: (CGSize)shadowOffset
				   titleFont: (UIFont *)font
		   contentEdgeInsets: (UIEdgeInsets)contentEdgeInsets
			 backgroundImage: (UIImage *)backgroundImage;

@end

#pragma mark - GNavigationController
@interface GNavigationController : UINavigationController

@property (nonatomic) BOOL canDragBack;  //default YES
@property (nonatomic) GNavigationAnimationType navigationAnimationType; //default hide

@end