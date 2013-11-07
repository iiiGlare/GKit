//
//  UIImage+GKit.h
//  GKitDemo
//
//  Created by Glare on 13-5-21.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

UIImage * GImageNamed(NSString *imageName);

@interface UIImage (GKit)

/*
 小尺寸图片
 */
- (UIImage *)smallImageWithSize:(CGSize)size;
- (UIImage *)smallImageWithSize:(CGSize)size fitWidth:(BOOL)fitWidth;

/*
 有需要使用图片素材的，可以试试用下面几个方法来自行创建 UIImage
 
 iOS 3.2 and later
 
 属性：
 size ：尺寸小，in points，不需要乘2
 cornerRadius : 圆角
 borderWidth、borderColor : 描边
 backgroundColor : 背景色，纯色
 backgroundColors : 背景色，渐变色，现在只支持从上到下两个色值的的线性渐变
 */

+ (UIImage *)imageWithSize:(CGSize)size
           backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
           backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
           backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
           backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
          backgroundColors:(NSArray *)backgroundColors;


@end
