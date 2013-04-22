//
//  GDayView.m
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GDayView.h"
#import "GCore.h"

#import "GEvent.h"
#import "GEventView.h"

#pragma mark - GDayGridView
@interface GDayGridView : UIView
@property (nonatomic, assign) CGFloat gridLineOffset;
@end
@implementation GDayGridView
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat hourHeight = (rect.size.height-2*_gridLineOffset)/GHoursInDay;
    CGFloat width = rect.size.width;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //hour lines
    CGContextSetLineWidth(c, 0.4);
    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGContextBeginPath(c);
    for (NSInteger i=0; i<GHoursInDay+1; i++) {
        CGFloat y = i*hourHeight+_gridLineOffset;
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, width, y);
    }
    CGContextClosePath(c);
    CGContextStrokePath(c);
    
    //half hour lines
    CGContextSetLineWidth(c, 0.4);
    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGFloat lengths[] = {3,2};
    CGContextSetLineDash(c, 0, lengths, 2);
    CGContextBeginPath(c);
    for (NSInteger i=0; i<GHoursInDay+1; i++) {
        CGFloat y = (i+0.5)*hourHeight+_gridLineOffset;
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, width, y);
    }
    CGContextClosePath(c);
    CGContextStrokePath(c);
}
@end

#pragma mark - GDayHourView
@interface GDayHourView : UIView
@property (nonatomic, strong) NSMutableArray *hourLabels;
@property (nonatomic, assign) CGFloat startCenterY;
@property (nonatomic, assign) CGFloat endCenterY;
@end
@implementation GDayHourView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _hourLabels = [NSMutableArray arrayWithCapacity:GHoursInDay+1];
        for (int i=0; i<GHoursInDay+1; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label.textAlignmentG = GTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%d",i];
            [self addSubview:label];
            [_hourLabels addObject:label];
        }
    }
    return self;
}
- (void)layoutSubviews
{
    CGFloat labelSpace = (_endCenterY-_startCenterY)/GHoursInDay;
    for (int i=0; i<[_hourLabels count]; i++) {
        UILabel  *label = [_hourLabels objectAtPosition:i];
        label.frame = CGRectMake(0, 0, [self width]-10, 21);
        CGPoint center = [self innerCenter];
        center.y = _startCenterY + labelSpace*i;
        [label setCenter:center];
    }
}
@end
#pragma mark - GDayView
@interface GDayView ()

//layout
@property (nonatomic, assign) CGFloat gridLineOffset;
@property (nonatomic, assign) CGFloat gridTopMargin;
@property (nonatomic, assign) CGFloat gridBottomMargin;
@property (nonatomic, assign) CGFloat gridHeight;
@property (nonatomic, assign) CGFloat hourHeight;
@property (nonatomic, assign) CGFloat hourViewWidth;

//subviews
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GDayGridView *dayGridView;
@property (nonatomic, strong) GDayHourView *dayHourView;

//data
@property (nonatomic, strong) NSMutableArray *events;

@end

@implementation GDayView

#pragma mark Init & Memeory Management
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    self.hourHeight = 60.0;
    self.hourViewWidth = 50.0;
    self.gridLineOffset = 1.0;
    self.gridTopMargin = 15.0;
    self.gridBottomMargin = 15.0;
    self.gridHeight = GHoursInDay * _hourHeight + 2 * _gridLineOffset;

    self.date = [NSDate date];
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.dayGridView];
    [self.scrollView addSubview:self.dayHourView];
}

#pragma mark Setter / Getter

- (UIScrollView *)scrollView
{
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (GDayGridView *)dayGridView
{
    if (_dayGridView==nil) {
        _dayGridView = [[GDayGridView alloc] initWithFrame:CGRectZero];
        _dayGridView.backgroundColor = [UIColor whiteColor];
        _dayGridView.gridLineOffset = self.gridLineOffset;
    }
    return _dayGridView;
}

- (GDayHourView *)dayHourView
{
    if (_dayHourView==nil) {
        _dayHourView = [[GDayHourView alloc] initWithFrame:CGRectZero];
        _dayHourView.backgroundColor = [UIColor whiteColor];
    }
    return _dayHourView;
}

#pragma mark Layout
- (void)layoutSubviews
{
    
    self.scrollView.frame = self.bounds;
    [self.scrollView setContentSize:CGSizeMake([_scrollView width],
                                               _gridHeight+_gridTopMargin+_gridBottomMargin)];
    
    self.dayGridView.frame = CGRectMake(0, _gridTopMargin,
                                        [_scrollView width], _gridHeight);
    
    self.dayHourView.startCenterY = _gridTopMargin + _gridLineOffset;
    self.dayHourView.endCenterY = _gridTopMargin + _gridHeight;
    self.dayHourView.frame = CGRectMake(0, 0,
                                        _hourViewWidth, _scrollView.contentSize.height);
    
    [self reloadData];
}
- (void)showEventView:(GEventView *)eventView
{
    GEvent *event = eventView.event;
    NSDate *beginDate = event.beginDate;
    NSDate *endDate = event.endDate;
    
    NSDate *beginPoint = [self.date beginPoint];
    NSDate *nextDayBeginPoint = [self.date nextDayBeginPoint];
    
    if ([beginDate compare:nextDayBeginPoint]!=NSOrderedAscending ||
        [endDate compare:beginPoint]==NSOrderedAscending)
    {
        return;
    }
    
    NSTimeInterval beginTimeInterval = [beginDate timeIntervalSinceDate:beginPoint];
    if (beginTimeInterval<0) beginTimeInterval = 0;
    NSTimeInterval endTimeInterval = [endDate timeIntervalSinceDate:beginPoint];
    if (endTimeInterval>GTimeIntervalFromHours(GHoursInDay)) endTimeInterval = GTimeIntervalFromHours(GHoursInDay);
    
    CGFloat beginY = _hourHeight * beginTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineOffset;
    CGFloat endY = _hourHeight * endTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineOffset;
    
    eventView.frame = CGRectMake(_hourViewWidth, beginY,
                                 [_scrollView contentSize].width - _hourViewWidth, endY-beginY);
    [_scrollView addSubview:eventView];
    
}
#pragma mark Load Data
- (void)reloadData
{
    //remove all event views
    [self.scrollView removeAllSubviewOfClass:[GEventView class]];
    
    //get events
    self.events = [NSMutableArray array];
    if (_dataSource &&
        [_dataSource respondsToSelector:@selector(dayView:eventsForDate:)])
    {
        [self.events addObjectsFromArray:[_dataSource dayView:self eventsForDate:self.date]];
        
    }
    
    //add event views
    for (GEvent *event in self.events)
    {
        GEventView *eventView = nil;
        if (_dataSource &&
            [_dataSource respondsToSelector:@selector(dayView:eventViewForEvent:)])
        {
            eventView = [_dataSource dayView:self eventViewForEvent:event];
        }
        if (eventView==nil)
        {
            eventView = [[GEventView alloc] init];
        }
        
        eventView.event = event;
        
        [self showEventView:eventView];
    }
}

#pragma mark - GMoveSpriteCatcherProtocol
//prepare
- (GMoveSnapshot *)prepareSnapshotForSprite:(UIView *)sprite
{
    return nil;
}
- (void)didPrepareSnapshot:(GMoveSnapshot *)snapshot
{
    
}
//moving snapshot
- (void)isCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    CGRect rect = [self convertRect:snapshot.frame fromView:snapshot.superview];
    if (CGRectGetMaxY(rect)>CGRectGetMaxY(self.scrollView.frame) &&
        CGRectGetMaxY(rect)<CGRectGetMaxY(self.scrollView.frame)+20) {
        [self.scrollView startAutoScrollToBottom];
    }else if (CGRectGetMinY(rect)<CGRectGetMinY(self.scrollView.frame) &&
              CGRectGetMinY(rect)>CGRectGetMinY(self.scrollView.frame)-20) {
        [self.scrollView startAutoScrollToTop];
    }else {
        [self.scrollView stopAutoScroll];
    }
}
//did finish
- (void)didCatchSnapshot:(GMoveSnapshot *)snapshot
{
    [self.scrollView stopAutoScroll];
}

#pragma makr - 

@end


