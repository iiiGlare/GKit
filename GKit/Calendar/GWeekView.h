//
//  GWeekView.h
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMove.h"
#import "NSDate+GKit.h"

@class GEventView, GEvent;
@protocol GWeekViewDataSource, GWeekViewDelegate;

#pragma mark - GWeekdayView
@interface GWeekdayView : UIView
@property (nonatomic, strong, readonly) NSArray *weekdayLabels;

@property (nonatomic, copy) UIFont *weekdayFont;
@property (nonatomic, copy) UIColor *weekdayColor;

@property (nonatomic, copy) UIFont *todayFont;
@property (nonatomic, copy) UIColor *todayColor;

@end


#pragma mark - GWeekView
@interface GWeekView : UIView
<GMoveSpriteCatcherProtocol>

@property (nonatomic, strong) GWeekdayView *weekdayView;

@property (nonatomic, assign) GWeekdayType firstWeekday;   //defalut GWeekdayTypeSunday
@property (nonatomic, copy) NSDate *day;
@property (nonatomic, copy, readonly) NSDate *beginningOfWeek;
@property (nonatomic, copy, readonly) NSDate *endingOfWeek;

- (void)jumpToToday;
- (void)goToNextWeek;
- (void)backToPreviousWeek;

@property (nonatomic, weak) id<GWeekViewDataSource> dataSource;
@property (nonatomic, weak) id<GWeekViewDelegate> delegate;

- (void)reloadData;

@end


#pragma mark - GWeekViewDataSource
@protocol GWeekViewDataSource <NSObject>

- (NSArray *)eventsForWeekView:(GWeekView *)weekView;

@optional
- (GEventView *)weekView:(GWeekView *)weekView eventViewForGEvent:(GEvent *)event;

@end

#pragma mark - GWeekViewDelegate
@protocol GWeekViewDelegate <NSObject>

@optional
- (void)weekView:(GWeekView *)weekView didRemoveGEvent:(GEvent *)event;
- (void)weekView:(GWeekView *)weekView didUpdateGEvent:(GEvent *)event;
- (void)weekView:(GWeekView *)weekView didSelectGEvent:(GEvent *)event;

- (void)weekView:(GWeekView *)weekView requireGEventAtDate:(NSDate *)date;

@end
