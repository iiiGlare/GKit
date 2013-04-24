//
//  GSlider.h
//  GKitDemo
//
//  Created by Hua Cao on 13-4-24.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSlider : UIControl

@property (nonatomic) CGFloat minValue;                     //default 0
@property (nonatomic) CGFloat maxValue;                     //default 100
@property (nonatomic) CGFloat visibleLength;                //default 50

@property(nonatomic, getter=isContinuous) BOOL continuous;  //default YES

@property (nonatomic) CGFloat value;                        //defalut 0
- (void)setValue:(float)value animated:(BOOL)animated;

@end
