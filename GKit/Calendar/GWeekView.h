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

#pragma mark - GWeekView
@interface GWeekView : UIView
<GMoveSpriteCatcherProtocol>

@property (nonatomic, assign) GWeekdayType firstWeekday;   //defalut GWeekdayTypeSunday
@property (nonatomic, copy) NSDate *day;
@property (nonatomic, copy, readonly) NSDate *beginningOfWeek;

- (void)jumpToToday;
- (void)goToNextWeek;
- (void)backToPreviousWeek;

//first weekday




@property (nonatomic, weak) id<GWeekViewDataSource> dataSource;
@property (nonatomic, weak) id<GWeekViewDelegate> delegate;

- (void)reloadData;

@end


#pragma mark - GWeekViewDataSource
@protocol GWeekViewDataSource <NSObject>

- (NSArray *)weekView:(GWeekView *)weekView eventsForDay:(NSDate *)day;

@optional
- (GEventView *)weekView:(GWeekView *)weekView eventViewForEvent:(GEvent *)event;

@end

#pragma mark - GWeekViewDelegate
@protocol GWeekViewDelegate <NSObject>

@optional
- (void)weekView:(GWeekView *)weekView didRemoveEvent:(GEvent *)event;
- (void)weekView:(GWeekView *)weekView didUpdateEvent:(GEvent *)event;
- (void)weekView:(GWeekView *)weekView didSelectEvent:(GEvent *)event;

@end
