//
//  GScrollSlider.h
//  GKitDemo
//
//  Created by Glare on 13-5-6.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GScrollSlider : UIControl

@property (nonatomic, strong, readonly) UIView *scalesView;   //刻度视图
@property (nonatomic, assign) CGFloat scalesViewTopMargin; // default 0
@property (nonatomic, assign) CGFloat scalesViewBottomMargin; // default 0

@property (nonatomic, copy) UIImage *minTrackImage; //用于指示滑块左侧
@property (nonatomic, copy) UIImage *maxTrackImage; //用于指示滑块右侧
@property (nonatomic, assign) CGFloat trackViewHeight; //default 5

@property (nonatomic, copy) UIImage *thumbImage; //滑块
@property (nonatomic, assign) CGSize thumbViewSize; //default (self.height, self.height)

@property (nonatomic, assign) CGFloat minValue; //default 0
@property (nonatomic, assign) CGFloat maxValue; //default 100
@property (nonatomic, assign) CGFloat value; //default 50
@property (nonatomic, assign) CGFloat visibleValueLength; //default 50

@property (nonatomic, assign, readonly) CGFloat visibleMinValue;
@property (nonatomic, assign, readonly) CGFloat visibleMaxValue;

@property (nonatomic, assign) CGFloat autoScrollStepValue; //default 1
@property (nonatomic, assign) NSInteger autoScrollStepsPerSecond; //default 10

- (void)setValue:(CGFloat)value animated:(BOOL)animated;
- (void)reloadSlider;

@end
