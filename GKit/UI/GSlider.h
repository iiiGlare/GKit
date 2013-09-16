//
//  GSlider.h
//  GKitDemo
//
//  Created by Hua Cao on 13-4-24.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSlider : UIControl

@property (nonatomic, assign) CGFloat minValue;                     //default 0
@property (nonatomic, assign) CGFloat maxValue;                     //default 100
@property (nonatomic, assign) CGFloat visibleLength;                //default 50

@property (nonatomic, assign, getter=isContinuous) BOOL continuous;  //default YES

@property (nonatomic, assign) CGFloat value;                        //defalut 0
- (void) setValue:(float)value animated:(BOOL)animated;

@end
