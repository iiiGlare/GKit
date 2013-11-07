//
//  UIImage+GKit.m
//  GKitDemo
//
//  Created by Glare on 13-5-21.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "UIImage+GKit.h"
#import <CoreGraphics/CoreGraphics.h>
#import "GCore.h"


UIImage * GImageNamed(NSString * imageName)
{
	return [UIImage imageNamed:imageName];
}


@implementation UIImage (GKit)

- (UIImage *)smallImageWithSize:(CGSize)size {
	return [self smallImageWithSize:size fitWidth:YES];
}

- (UIImage *)smallImageWithSize:(CGSize)size
                       fitWidth:(BOOL)fitWidth {
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	CGSize drawSize;
	if (fitWidth) {
		drawSize = CGSizeMake(size.width, (self.size.height/self.size.width)*size.width);
	}
    else{
		drawSize = CGSizeMake((self.size.width/self.size.height)*size.height, size.height);
	}
	
	[self drawInRect:CGRectMake(0, -(drawSize.height-size.height)/2.0, drawSize.width, drawSize.height)];
	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

//
+ (UIImage *)imageWithSize:(CGSize)size
           backgroundColor:(UIColor *)backgroundColor {
    return [UIImage imageWithSize:size
                     cornerRadius:0
                      borderWidth:0
                      borderColor:nil
                  backgroundColor:backgroundColor];
}

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
           backgroundColor:(UIColor *)backgroundColor {
    return [UIImage imageWithSize:size
                     cornerRadius:cornerRadius
                      borderWidth:0
                      borderColor:nil
                  backgroundColor:backgroundColor];
}

+ (UIImage *)imageWithSize:(CGSize)size
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
           backgroundColor:(UIColor *)backgroundColor {
    return [UIImage imageWithSize:size
                     cornerRadius:0
                      borderWidth:borderWidth
                      borderColor:borderColor
                  backgroundColor:backgroundColor];
}

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
           backgroundColor:(UIColor *)backgroundColor {
    return [UIImage imageWithSize:size
                     cornerRadius:cornerRadius
                      borderWidth:borderWidth
                      borderColor:borderColor
                 backgroundColors:@[backgroundColor?:[UIColor whiteColor]]];
}

+ (UIImage *)imageWithSize:(CGSize)size
              cornerRadius:(CGFloat)cornerRadius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
          backgroundColors:(NSArray *)backgroundColors {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // border
    if ((borderWidth > 0.0f) && borderColor && [borderColor isKindOfClass:[UIColor class]]) {
        CGRect borderRect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath * borderBezierPath = [UIBezierPath bezierPathWithRoundedRect:borderRect
                                                                     cornerRadius:cornerRadius];
        [borderColor setFill];
        [borderBezierPath fill];
    }
    
    // background
    if (backgroundColors && ![backgroundColors isEmpty]) {
        // background bezier path
        CGFloat doubleBorderWidth = borderWidth * 2;
        CGRect backgroundRect = CGRectMake(borderWidth,
                                           borderWidth,
                                           size.width - doubleBorderWidth,
                                           size.height - doubleBorderWidth);
        UIBezierPath * backgroundBezierPath = [UIBezierPath bezierPathWithRoundedRect:backgroundRect
                                                                         cornerRadius:cornerRadius];
        
        if (backgroundColors.count==1) {
            // pure color
            UIColor * backgroundColor = [backgroundColors firstObject];
            [backgroundColor setFill];
            [backgroundBezierPath fill];
        }
        else {
            // gradient color
            [backgroundBezierPath addClip];
            
            UIColor * myStartColor = [backgroundColors firstObject];
            UIColor * myEndColor = [backgroundColors lastObject];
            
            CGGradientRef myGradient;
            CGColorSpaceRef myColorspace;
            size_t num_locations = 2;
            CGFloat locations[2] = { 0.0, 1.0 };
            
            const CGFloat * startColorComponents = CGColorGetComponents(myStartColor.CGColor);
            size_t num_s = CGColorGetNumberOfComponents(myStartColor.CGColor);
            CGFloat s_red = startColorComponents[0];
            CGFloat s_green = num_s==2?s_red:startColorComponents[1];
            CGFloat s_blue = num_s==2?s_red:startColorComponents[2];
            CGFloat s_alpha = num_s==2?startColorComponents[1]:startColorComponents[3];
            
            const CGFloat * endColorComponents = CGColorGetComponents(myEndColor.CGColor);
            size_t num_e = CGColorGetNumberOfComponents(myEndColor.CGColor);
            CGFloat e_red = endColorComponents[0];
            CGFloat e_green = num_e==2?e_red:endColorComponents[1];
            CGFloat e_blue = num_e==2?e_red:endColorComponents[2];
            CGFloat e_alpha = num_e==2?endColorComponents[1]:endColorComponents[3];
            
            CGFloat components[8] = {
                s_red, s_green, s_blue, s_alpha,  // Start color
                e_red, e_green, e_blue, e_alpha // End color
            };
            
            myColorspace = CGColorSpaceCreateDeviceRGB();
            myGradient = CGGradientCreateWithColorComponents (myColorspace,
                                                              components,
                                                              locations,
                                                              num_locations);
            
            CGContextRef myContext = UIGraphicsGetCurrentContext();
            CGPoint myStartPoint, myEndPoint;
            myStartPoint.x = 0.0;
            myStartPoint.y = 0.0;
            myEndPoint.x = 0.0;
            myEndPoint.y = size.height;
            CGContextDrawLinearGradient (myContext, myGradient, myStartPoint, myEndPoint, 0);
            CFRelease(myColorspace);
            CFRelease(myGradient);
        }
    }
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return result;
}

@end
