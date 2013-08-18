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
@property (nonatomic, copy) NSDate * day;    // time always is 00:00:00
@property (nonatomic, copy, readonly) NSDate * beginningOfWeek;  // time always is 00:00:00
@property (nonatomic, copy, readonly) NSDate * endingOfWeek; // time always is 00:00:00

- (void)jumpToToday;
- (void)goToNextWeek;
- (void)backToPreviousWeek;

@property (nonatomic, weak) id<GWeekViewDataSource> dataSource;
@property (nonatomic, weak) id<GWeekViewDelegate> delegate;

- (void)reloadData;

// time line
@property (nonatomic, strong, readonly) UIView * timeIndicator;
@property (nonatomic, assign) CGFloat timeIndicatorOffset; // default 1 hour height

// grid view
@property (nonatomic, strong) UIColor * gridLineColor;      // default gray color
@property (nonatomic, assign) BOOL showGirdHalfHourLines;       // default YES
@property (nonatomic, assign) BOOL isGridHalfLineDashed;        // default YES

// hour
@property (nonatomic, strong) UIColor * hourViewBackgroundColor;      // default clear color
@property (nonatomic, assign) BOOL showHalfHours;    // default NO
@property (nonatomic, assign) BOOL centerHours;      // default NO
@property (nonatomic, assign) CGFloat hourHeight;    // default 60.0f
@property (nonatomic, strong) UIFont * hourTextFont;    // default systemfont 12.0f
@property (nonatomic, strong) UIColor * hourTextColor;  // default gray color

// day
@property (nonatomic, assign) CGFloat dayViewHeight;            // default 30
@property (nonatomic, assign) CGFloat dayTitleBottomMargin;     // default 5
@property (nonatomic, strong) UIFont * weekdayFont;               // default systemfont 12.0f
@property (nonatomic, strong) UIColor * weekdayColor;             // default gray color
@property (nonatomic, strong) UIFont * todayFont;                 // default systemfont 12.0f
@property (nonatomic, strong) UIColor * todayColor;               // default blue color

// moving
@property (nonatomic, strong) UIColor * eventViewMovingBackgroundColor;

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
- (void)weekView:(GWeekView *)weekView didSelectGEvents:(NSArray *)gEvents;

- (GEvent *)weekView:(GWeekView *)weekView requireGEventAtDate:(NSDate *)date;

@end
