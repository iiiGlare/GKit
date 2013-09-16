//
//  GSwitch.h
//  GKitDemo_arc
//
//  Created by Hua Cao on 12-9-12.
//  Copyright (c) 2012年 hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSwitch : UIControl

//图片
@property (nonatomic, strong) UIImage * knobImage;
@property (nonatomic, strong) UIImage * onToggleImage;
@property (nonatomic, strong) UIImage * offToggleImage;

@property (nonatomic, strong) UIImage * onBackgroundImage;
@property (nonatomic, strong) UIImage * offBackgroundImage;


//尺寸
@property (nonatomic, assign) CGSize knobSize;
@property (nonatomic, assign) CGFloat toggleHeight;
@property (nonatomic, assign, getter = isStretchable) BOOL stretchable;

//边距 位移
@property (nonatomic, assign) UIEdgeInsets knobInsets;
@property (nonatomic, assign) UIEdgeInsets toggleInsets;

@property (nonatomic, assign, getter = isOn) BOOL on;


- (id) initWithFrame: (CGRect)frame
		   knobImage: (UIImage *)knobImage
       onToggleImage: (UIImage *)onToggleImage
      offToggleImage: (UIImage *)offToggleImage;


- (void) setOn:(BOOL)newOn animated:(BOOL)animated;
- (void) setOn:(BOOL)newOn animated:(BOOL)animated ignoreControlEvents:(BOOL)ignoreControlEvents;

@end
