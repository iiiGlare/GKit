//
//  GDayView.h
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMove.h"

@class GEventView, GEvent;
@protocol GDayViewDataSource, GDayViewDelegate;

#pragma mark - GDayView
@interface GDayView : UIView
<GMoveSpriteCatcherProtocol>

@property (nonatomic, copy) NSDate *day;
@property (nonatomic, copy, readonly) NSDate *nextDay;
@property (nonatomic, copy, readonly) NSDate *previousDay;
- (void)jumpToToday;
- (void)goToNextDay;
- (void)backToPreviousDay;

@property (nonatomic, weak) id<GDayViewDataSource> dataSource;
@property (nonatomic, weak) id<GDayViewDelegate> delegate;

- (void)reloadData;
- (BOOL)canShowEvent:(GEvent *)event;


@end

#pragma mark - Called By Catcher
@interface GDayView (CalledByCatcher)

//prepare
- (GMoveSnapshot *)dayViewPrepareSnapshotForOwnEventView:(GEventView *)eventView;
- (CGRect)dayViewrepareFrameForSnapshot:(GMoveSnapshot *)snapshot;
- (void)dayViewDidPrepareSnapshot:(GMoveSnapshot *)snapshot;
//moving event
- (void)dayViewBeginCatchingSnapshot:(GMoveSnapshot *)snapshot withEvent:(GEvent *)event;
- (void)dayViewIsCatchingSnapshot:(GMoveSnapshot *)snapshot;
- (void)dayViewEndCatchingSnapshot:(GMoveSnapshot *)snapshot;
//end
- (void)dayViewDidCatchSnapshot:(GMoveSnapshot *)snapshot withEvent:(GEvent *)event;
- (void)dayViewRemoveOwnEventView:(GEventView *)eventView;

@end

#pragma mark - GDayViewDataSource
@protocol GDayViewDataSource <NSObject>

- (NSArray *)eventsForDayView:(GDayView *)dayView;

@optional
- (GEventView *)dayView:(GDayView *)dayView eventViewForEvent:(GEvent *)event;

@end

#pragma mark - GDayViewDelegate
@protocol GDayViewDelegate <NSObject>

@optional
- (void)dayView:(GDayView *)dayView didRemoveEvent:(GEvent *)event;
- (void)dayView:(GDayView *)dayView didUpdateEvent:(GEvent *)event;
- (void)dayView:(GDayView *)dayView didSelectEvent:(GEvent *)event;

@end
