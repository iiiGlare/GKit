//
//  GNavigationController.h
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GConfigurator.h"

enum {
    GNavigationAnimationTypeNormal,
    GNavigationAnimationTypeHide
};
typedef NSInteger GNavigationAnimationType;

#pragma mark - GNavigationController
@interface GNavigationController : UINavigationController <
GConfigurator >

@property (nonatomic) BOOL canDragBack;  G_CONFIGURATOR_SELECTOR //default NO
@property (nonatomic) GNavigationAnimationType navigationAnimationType; G_CONFIGURATOR_SELECTOR //default GNavigationAnimationTypeNormal

- (void) setBackItemWithImage: (UIImage *)image
            hightlightedImage: (UIImage *)hightlightedImage
                        title: (NSString *)title
                   titleColor: (UIColor *)color
         titleHightlightColor: (UIColor *)hColor
             titleShadowColor: (UIColor *)shadowColor
            titleShadowOffset: (CGSize)shadowOffset
                    titleFont: (UIFont *)font
            contentEdgeInsets: (UIEdgeInsets)contentEdgeInsets
              backgroundImage: (UIImage *)backgroundImage
  backgroundHightlightedImage: (UIImage *)backgroundHightlightedImage;	G_CONFIGURATOR_SELECTOR


@end