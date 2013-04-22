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
@protocol GDayViewDataSource;

#pragma mark - GDayView

@interface GDayView : UIView
<GMoveSpriteCatcherProtocol>

@property (nonatomic, copy) NSDate *date;

@property (nonatomic, weak) id<GDayViewDataSource> dataSource;

- (void)reloadData;

@end

#pragma mark - GDayViewDataSource

@protocol GDayViewDataSource <NSObject>

- (NSArray *)dayView:(GDayView *)dayView eventsForDate:(NSDate *)date;

@optional
- (GEventView *)dayView:(GDayView *)dayView eventViewForEvent:(GEvent *)event;

@end
