//
//  UIScrollView+GKit.h
//  CalendarDemo
//
//  Created by Glare on 13-4-20.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (GKit)

@property (nonatomic, strong) NSTimer *autoScrollTopTimer;
@property (nonatomic, strong) NSTimer *autoScrollBottomTimer;
- (void)startAutoScrollToTop;
- (void)autoScrollToTop;
- (void)startAutoScrollToBottom;
- (void)autoScrollToBottom;
- (void)stopAutoScroll;

@end
