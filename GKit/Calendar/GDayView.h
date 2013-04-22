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

@property (nonatomic, copy) NSDate *date;

@property (nonatomic, weak) id<GDayViewDataSource> dataSource;
@property (nonatomic, weak) id<GDayViewDelegate> delegate;

- (void)reloadData;

@end

#pragma mark - GDayViewDataSource

@protocol GDayViewDataSource <NSObject>

- (NSArray *)dayView:(GDayView *)dayView eventsForDate:(NSDate *)date;

@optional
- (GEventView *)dayView:(GDayView *)dayView eventViewForEvent:(GEvent *)event;

@end


#pragma mark - GDayViewDelegate

@protocol GDayViewDelegate <NSObject>

@optional
- (void)dayView:(GDayView *)dayView didRemoveEvent:(GEvent *)event;
- (void)dayView:(GDayView *)dayView didChangeEvent:(GEvent *)event;

@end
