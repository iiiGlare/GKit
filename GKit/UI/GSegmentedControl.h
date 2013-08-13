//
//  GSegmentedControl.h
//  competitionReminder
//
//  Created by 华 曹 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSegmentedControl : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIImage *normalBackgroundImage;
@property (nonatomic, strong) UIImage *selectedBackgroundImage;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

+ (GSegmentedControl *)segmentedControlWithTitles:(NSArray *)titles;

- (void)setFont:(UIFont *)font;
- (void)setTextColor:(UIColor *)color forControlSate:(UIControlState)controlState;
- (void)setBackgroundImage:(UIImage *)backgroundImage forControlSate:(UIControlState)controlState;
- (void)addTarget:(id)theTarget action:(SEL)theAction;

@property (nonatomic, copy) void (^eventHandler)(id sender);
- (void)addEventHandler:(void (^)(id sender))eventHandler;

@end
