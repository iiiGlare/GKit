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

@property (nonatomic, copy) NSDate *day;    // time always is 00:00:00
@property (nonatomic, copy, readonly) NSDate *nextDay; // time always is 00:00:00
@property (nonatomic, copy, readonly) NSDate *previousDay; // time always is 00:00:00
- (void)jumpToToday;
- (void)goToNextDay;
- (void)backToPreviousDay;

@property (nonatomic, weak) id<GDayViewDataSource> dataSource;
@property (nonatomic, weak) id<GDayViewDelegate> delegate;

- (void)reloadData;
- (BOOL)canShowGEvent:(GEvent *)gEvent;

- (CGFloat)offsetForDate:(NSDate *)date;

// time line
@property (nonatomic, strong, readonly) UIView * timeIndicator;
@property (nonatomic, assign) CGFloat timeIndicatorOffset; // default 1 hour height

// grid view
@property (nonatomic, strong) UIColor * gridLineColor;      // default gray color
@property (nonatomic, assign) BOOL isGridHalfLineDashed;    // default YES

// hour
@property (nonatomic, assign) BOOL showHalfHours;       // default NO
@property (nonatomic, assign) BOOL centerHours;         // default NO
@property (nonatomic, assign) CGFloat hourHeight;       // default 60.0f
@property (nonatomic, strong) UIFont * hourTextFont;    // default systemfont 12.0f
@property (nonatomic, strong) UIColor * hourTextColor;  // default gray color

@end

#pragma mark - Called By Catcher
@interface GDayView (CalledByCatcher)

//prepare
- (GMoveSnapshot *)dayViewPrepareSnapshotForOwnEventView:(GEventView *)eventView;
- (CGRect)dayViewrepareFrameForSnapshot:(GMoveSnapshot *)snapshot;
- (void)dayViewDidPrepareSnapshot:(GMoveSnapshot *)snapshot;
//moving event
- (void)dayViewBeginCatchingSnapshot:(GMoveSnapshot *)snapshot withGEvent:(GEvent *)gEvent;
- (void)dayViewIsCatchingSnapshot:(GMoveSnapshot *)snapshot;
- (void)dayViewEndCatchingSnapshot:(GMoveSnapshot *)snapshot;
//end
- (void)dayViewDidCatchSnapshot:(GMoveSnapshot *)snapshot withGEvent:(GEvent *)gEvent;
- (void)dayViewRemoveOwnEventView:(GEventView *)eventView;

@end

#pragma mark - GDayViewDataSource
@protocol GDayViewDataSource <NSObject>

- (NSArray *)eventsForDayView:(GDayView *)dayView;

@optional
- (GEventView *)dayView:(GDayView *)dayView eventViewForGEvent:(GEvent *)gEvent;

@end

#pragma mark - GDayViewDelegate
@protocol GDayViewDelegate <NSObject>

@optional
- (void)dayView:(GDayView *)dayView didRemoveGEvent:(GEvent *)gEvent;
- (void)dayView:(GDayView *)dayView didUpdateGEvent:(GEvent *)gEvent;
- (void)dayView:(GDayView *)dayView didSelectGEvent:(GEvent *)gEvent;

- (void)dayView:(GDayView *)dayView requireGEventAtDate:(NSDate *)date;

@end
