//
//  GBorderView.h
//  GKitDemo
//
//  Created by Hua Cao on 13-9-3.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBorderView : UIView

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor * fillColor;
@property (nonatomic, strong) UIColor * shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;

@end
