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

//小尺寸图片
- (UIImage *)smallImageWithSize:(CGSize)size;
- (UIImage *)smallImageWithSize:(CGSize)size fitWidth:(BOOL)fitWidth;


@end
