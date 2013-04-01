//
//  GView.h
//  GKitDemo
//
//  Created by Glare on 13-3-31.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GView : UIView

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bottomView;

- (void)setTopViewHeight:(CGFloat)topViewHeight;
- (void)setContentViewHeight:(CGFloat)contentViewHeight;
- (void)setBottomViewHeight:(CGFloat)bottomViewHeight;

@end
