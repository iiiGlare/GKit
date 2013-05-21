//
//  UIImage+GKit.m
//  GKitDemo
//
//  Created by Glare on 13-5-21.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "UIImage+GKit.h"
#import "GMacros.h"

UIImage * GImageNamed(NSString * imageName)
{
	return [UIImage imageNamed:imageName];
}


@implementation UIImage (GKit)

- (UIImage *)smallImageWithSize:(CGSize)size
{
	//尺寸适应
	return [self smallImageWithSize:size fitWidth:YES];
}

- (UIImage *)smallImageWithSize:(CGSize)size fitWidth:(BOOL)fitWidth
{
	//尺寸适应
	CGSize usedSize = CGSizeMake(size.width * GScreenScale, size.height * GScreenScale);
	
	UIImage *result = nil;
	UIGraphicsBeginImageContext(usedSize);
	CGSize drawSize;
	if (fitWidth) {
		drawSize = CGSizeMake(usedSize.width, (self.size.height/self.size.width)*usedSize.width);
	}else{
		drawSize = CGSizeMake((self.size.width/self.size.height)*usedSize.height, usedSize.height);
	}
	
	[self drawInRect:CGRectMake(0, -(drawSize.height-usedSize.height)/2.0, drawSize.width, drawSize.height)];
	result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}


@end
