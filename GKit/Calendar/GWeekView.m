//
//  GWeekView.m
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GWeekView.h"
#import "GCore.h"
#import "GEvent.h"
#import "GEventView.h"
#import "GMoveSnapshot+GCalendar.h"
#pragma mark - GWeekGridView
@interface GWeekGridView : UIView
@property (nonatomic, assign) CGFloat hourViewWidth;
@property (nonatomic, assign) CGFloat gridLineTopMargin;
@property (nonatomic, assign) CGFloat gridLineBottomMargin;
@end

@implementation GWeekGridView
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat dayWidth = gfloor((rect.size.width-_hourViewWidth)/GDaysInWeek);
    CGFloat height = rect.size.height;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //day lines
    CGContextSetLineWidth(c, 0.4);
    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGContextBeginPath(c);
    for (NSInteger i=1; i<GDaysInWeek; i++) {
        CGFloat x = i*dayWidth + _hourViewWidth;
        CGContextMoveToPoint(c, x, _gridLineTopMargin);
        CGContextAddLineToPoint(c, x, height-_gridLineBottomMargin);
    }
    CGContextStrokePath(c);
    
    
    CGFloat hourHeight = (rect.size.height-_gridLineTopMargin-_gridLineBottomMargin)/GHoursInDay;
    CGFloat width = rect.size.width;
    
    //hour lines
    CGContextSetLineWidth(c, 0.4);
    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGContextBeginPath(c);
    for (NSInteger i=0; i<GHoursInDay+1; i++) {
        CGFloat y = i*hourHeight+_gridLineTopMargin;
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, width, y);
    }
    CGContextStrokePath(c);
    
    //half hour lines
    CGContextSetLineWidth(c, 0.4);
    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGFloat lengths[] = {3,2};
    CGContextSetLineDash(c, 0, lengths, 2);
    CGContextBeginPath(c);
    for (NSInteger i=0; i<GHoursInDay; i++) {
        CGFloat y = (i+0.5)*hourHeight+_gridLineTopMargin;
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, width, y);
    }
    CGContextStrokePath(c);

}

@end

#pragma mark - GWeekdayView
@interface GWeekdayView : UIView

@property (nonatomic, assign) GWeekdayType firstWeekday;

@property (nonatomic, assign) CGFloat hourViewWidth;
@property (nonatomic, assign) CGFloat dayTitleBottomMargin;
@property (nonatomic, strong) NSArray *weekdayLabels;
@end

@implementation GWeekdayView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *weekdayLabels = [NSMutableArray arrayWithCapacity:GDaysInWeek];
        for (int i=0; i<GDaysInWeek; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
            label.textAlignmentG = GTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            [weekdayLabels addObject:label];
        }
        self.weekdayLabels = weekdayLabels;
    }
    return self;
}
- (void)layoutSubviews
{
    CGFloat labelWidth = gfloor((self.width-_hourViewWidth)/GDaysInWeek);
    NSArray *weekdaySymbols = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    for (int i=0; i<[_weekdayLabels count]; i++) {
        UILabel  *label = [_weekdayLabels objectAtPosition:i];
        label.text = [weekdaySymbols objectAtCirclePosition:_firstWeekday-GWeekdayTypeSunday+i];
        [label sizeToFit];
        label.frame = CGRectMake(_hourViewWidth+labelWidth*i,
                                 self.height-label.height-_dayTitleBottomMargin,
                                 labelWidth,
                                 label.height);
    }
}
@end


#pragma mark - GWeekHourView
@interface GWeekHourView : UIView
@property (nonatomic, strong) NSMutableArray *hourLabels;
@property (nonatomic, assign) CGFloat startCenterY;
@property (nonatomic, assign) CGFloat endCenterY;
@end
@implementation GWeekHourView
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
        label.text = [NSString stringWithFormat:@"%d",i];
    }
}
@end


#pragma mark - GWeekView
@interface GWeekView ()

//layout
@property (nonatomic, assign) CGFloat gridHeight;
@property (nonatomic, assign) CGFloat gridTopMargin;
@property (nonatomic, assign) CGFloat gridBottomMargin;
@property (nonatomic, assign) CGFloat gridLineTopMargin;
@property (nonatomic, assign) CGFloat gridLineBottomMargin;

@property (nonatomic, assign) CGFloat hourViewWidth;
@property (nonatomic, assign) CGFloat hourHeight;

@property (nonatomic, assign) CGFloat dayViewHeight;
@property (nonatomic, assign) CGFloat dayTitleBottomMargin;

//
@property (nonatomic, assign) CGFloat dayEventViewWidth;
@property (nonatomic, assign) CGFloat dayBeginTimeOffset;
@property (nonatomic, assign) CGFloat dayEndTimeOffset;

//subviews
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GWeekGridView *weekGridView;
@property (nonatomic, strong) GWeekdayView *weekdayView;
@property (nonatomic, strong) GWeekHourView *weekHourView;


//move
@property (nonatomic, weak) GEventView *movingEventView;
@property (nonatomic) CGFloat snapshotAlpha;

@end

@implementation GWeekView

#pragma mark Init & Memeory Management
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInitialize];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInitialize];
    }
    return self;
}
- (void)customInitialize
{    
    _hourHeight = 60.0;
    _hourViewWidth = 50.0;
    
    _dayViewHeight = 30.0;
    _dayTitleBottomMargin = 5.0;

    _gridTopMargin = 5.0;
    _gridBottomMargin = 15.0;
    _gridLineTopMargin = 1.0 + _dayViewHeight;
    _gridLineBottomMargin = 1.0;
    _gridHeight = GHoursInDay * _hourHeight + _gridLineTopMargin + _gridLineBottomMargin;

    _firstWeekday = GWeekdayTypeSunday;
    
    //Tap Gesture
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGR];
    
}

- (void)didMoveToSuperview
{
    if (_scrollView==nil)
    {
        [self.scrollView addSubview:self.weekGridView];
        [self.scrollView addSubview:self.weekdayView];
        [self.scrollView addSubview:self.weekHourView];
        [self addSubview:self.scrollView];
    }
}

#pragma mark Setter / Getter

- (UIScrollView *)scrollView
{
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.autoresizingMask = GViewAutoresizingFlexibleSize;
    }
    return _scrollView;
}

- (GWeekGridView *)weekGridView
{
    if (_weekGridView==nil) {
        _weekGridView = [[GWeekGridView alloc] initWithFrame:
                         CGRectMake(0, _gridTopMargin, _scrollView.width, _gridHeight)];
        _weekGridView.backgroundColor = [UIColor whiteColor];
        _weekGridView.hourViewWidth = _hourViewWidth;
        _weekGridView.gridLineTopMargin = _gridLineTopMargin;
        _weekGridView.gridLineBottomMargin = _gridLineBottomMargin;
    }
    return _weekGridView;
}

- (GWeekHourView *)weekHourView
{
    if (_weekHourView==nil) {
        _weekHourView = [[GWeekHourView alloc] initWithFrame:
                         CGRectMake(0, 0, _hourViewWidth, _scrollView.contentSize.height)];
        _weekHourView.backgroundColor = [UIColor whiteColor];
        _weekHourView.startCenterY = _gridTopMargin + _gridLineTopMargin;
        _weekHourView.endCenterY = _gridTopMargin + _gridHeight - _gridLineBottomMargin;

    }
    return _weekHourView;
}

- (GWeekdayView *)weekdayView
{
    if (_weekdayView==nil) {
        _weekdayView = [[GWeekdayView alloc] initWithFrame:
                        CGRectMake(0, _gridTopMargin, _scrollView.width, _dayViewHeight)];
        _weekdayView.backgroundColor = [UIColor whiteColor];
        _weekdayView.hourViewWidth = _hourViewWidth;
        _weekdayView.dayTitleBottomMargin = _dayTitleBottomMargin;
        _weekdayView.firstWeekday = _firstWeekday;
    }
    return _weekdayView;
}

- (void)setDay:(NSDate *)day
{
    _day = [day beginningOfDay];
    _beginningOfWeek = [day beginningOfWeekWithFirstWeekday:_firstWeekday];
}

- (void)setFirstWeekday:(GWeekdayType)firstWeekday
{
    _firstWeekday = firstWeekday;
    _beginningOfWeek = [_day beginningOfWeekWithFirstWeekday:_firstWeekday];
}

#pragma mark - Action
- (void)jumpToToday
{
    NSDate *today = [[NSDate date] beginningOfDay];
    if ([self.day isEqualToDate:today]) return;
    
    self.day = today;
    [self reloadData];
}
- (void)goToNextWeek
{
    self.day = [self.day dateByAddingTimeInterval:GTimeIntervalFromDays(GDaysInWeek)];
    [self reloadData];
}
- (void)backToPreviousWeek
{
    self.day = [self.day dateByAddingTimeInterval:-GTimeIntervalFromDays(GDaysInWeek)];
    [self reloadData];    
}

- (void)reloadData
{
    //remove all event views
    [self.scrollView removeAllSubviewOfClass:[GEventView class]];
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _gridHeight+_gridTopMargin+_gridBottomMargin);
    _dayEventViewWidth = gfloor(([_scrollView contentSize].width - _hourViewWidth)/GDaysInWeek);
    _dayBeginTimeOffset = _gridTopMargin + _gridLineTopMargin;
    _dayEndTimeOffset = _hourHeight*GHoursInDay + _dayBeginTimeOffset;
    
    //show events
    if (_dataSource &&
        [_dataSource respondsToSelector:@selector(weekView:eventsForDay:)])
    {
        for (NSInteger i=0; i<GDaysInWeek; i++)
        {
            NSDate *day = [self.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(i)];
            NSArray *events = [_dataSource weekView:self eventsForDay:day];
            for (GEvent *event in events)
            {
                [self layoutEvent:event atDayPosition:i];
            }
        }
    }    
}

#pragma mark Layout
- (void)layoutEvent:(GEvent *)event atDayPosition:(NSInteger)dayPosition
{
    GEventView *eventView = [self eventViewForEvent:event atDayPosition:dayPosition];
    if (eventView)
    {
        [_scrollView addSubview:eventView];
        
        [self layoutEventViewsFromBeginY: eventView.y
                                  toEndY: eventView.y + eventView.height
                           atDayPosition: dayPosition
                                animated: NO];
    }
}

- (void)layoutEventViewsFromBeginY: (CGFloat)beginY
                            toEndY: (CGFloat)endY
                     atDayPosition: (NSInteger)dayPosition
                          animated: (BOOL)animated
{
    //
    NSMutableArray *sameTimeViews = [NSMutableArray array];
    for (UIView *view in [_scrollView subviews]) {
        if ([view isKindOfClass:[GEventView class]]) {
            CGFloat viewBeginY = CGRectGetMinY(view.frame);
            CGFloat viewEndY = CGRectGetMaxY(view.frame);
            if (!(viewEndY<=beginY || viewBeginY>=endY))
            {
                CGFloat viewBeginX = CGRectGetMinX(view.frame);
                CGFloat viewEndX = CGRectGetMaxX(view.frame);
                
                if (viewBeginX>=_hourViewWidth+_dayEventViewWidth*dayPosition &&
                    viewEndX<=_hourViewWidth+_dayEventViewWidth*(dayPosition+1))
                {    
                    [sameTimeViews addObject:view];
                }
            }
        }
    }
    
    //
    CGFloat eventViewWidth = _dayEventViewWidth/[sameTimeViews count];
    
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
    }
    for (NSInteger i=0; i<[sameTimeViews count]; i++) {
        GEventView *view = [sameTimeViews objectAtPosition:i];
        CGFloat x = _hourViewWidth + _dayEventViewWidth*dayPosition + i*eventViewWidth;
        CGFloat y = MAX(view.y, _dayBeginTimeOffset);
        CGFloat w = eventViewWidth;
        CGFloat h = MIN(CGRectGetMaxY(view.frame), _dayEndTimeOffset) - y;
        view.frame = CGRectMake(x,y,w,h);
    }
    if (animated)
    {
        [UIView commitAnimations];
    }
}


- (GEventView *)eventViewForEvent:(GEvent *)event atDayPosition:(NSInteger)dayPosition
{
    CGRect frame = [self frameForEvent:event atDayPosition:dayPosition];
    if (CGRectEqualToRect(frame, CGRectZero)) return nil;
    
    GEventView *eventView = nil;
    if (_dataSource &&
        [_dataSource respondsToSelector:@selector(weekView:eventViewForEvent:)])
    {
        eventView = [_dataSource weekView:self eventViewForEvent:event];
    }
    if (eventView==nil)
    {
        eventView = [[GEventView alloc] init];
    }
    
    eventView.event = event;
    eventView.frame = frame;
    
    return eventView;
}


- (CGRect)frameForEvent:(GEvent *)event atDayPosition:(NSInteger)dayPosition
{
    if (![self canShowEvent:event atDayPosition:dayPosition]) return CGRectZero;

    NSDate *dayBeginPoint = [self.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(dayPosition)];
    
    //
    NSTimeInterval beginTimeInterval = [event.beginTime timeIntervalSinceDate:dayBeginPoint];
    NSTimeInterval endTimeInterval = [event.endTime timeIntervalSinceDate:dayBeginPoint];
    
    CGFloat beginY = _hourHeight * beginTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineTopMargin;
    CGFloat endY = _hourHeight * endTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineTopMargin;
    
    return CGRectMake(_hourViewWidth + _dayEventViewWidth*dayPosition, beginY,
                      _dayEventViewWidth, endY-beginY);
}

- (BOOL)canShowEvent:(GEvent *)event atDayPosition:(NSInteger)dayPosition
{
    NSDate *dayBeginPoint = [self.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(dayPosition)];
    NSDate *nextDayBeginPoint = [dayBeginPoint dateByAddingTimeInterval:GTimeIntervalFromDays(1)];
    
    if ([event.beginTime compare:nextDayBeginPoint]!=NSOrderedAscending ||
        [event.endTime compare:dayBeginPoint]!=NSOrderedDescending)
    {
        return NO;
    }
    
    return YES;
}

- (NSDate *)dateForOffset:(CGFloat)offset atDayPosition:(NSInteger)dayPosition
{
    NSTimeInterval interval = gfloor(((offset-_dayBeginTimeOffset)/self.hourHeight)*GTimeIntervalFromHours(1));
    return [NSDate dateWithTimeInterval:interval sinceDate:[self.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(dayPosition)]];
}

- (NSInteger)dayPositionOfPoint:(CGPoint)point
{
    return gfloor((point.x - _hourViewWidth)/_dayEventViewWidth);
}

#pragma mark Gesture Recognizer
- (void)handleTap:(UITapGestureRecognizer *)tapGR
{
    
}

#pragma mark GMoveSpriteCatcherProtocol
//preprare
- (GMoveSnapshot *)prepareSnapshotForOwnSprite:(UIView *)sprite
{
    if ([sprite isKindOfClass:[GEventView class]]) {
        return [self weekViewPrepareSnapshotForOwnEventView:(GEventView *)sprite];
    }else{
        return nil;
    }
    
}
- (CGRect)prepareFrameForSnapshot:(GMoveSnapshot *)snapshot
{
    if ([snapshot.sprite isKindOfClass:[GEventView class]]) {
        return [self weekViewPrepareFrameForSnapshot:snapshot];
    }else{
        return snapshot.frame;
    }
}
- (void)didPrepareSnapshot:(GMoveSnapshot *)snapshot
{
    if ([snapshot.sprite isKindOfClass:[GEventView class]]) {
        [self weekViewDidPrepareSnapshot:snapshot];
    }
}

//moving snapshot
- (void)beginCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self weekViewBeginCatchingSnapshot:snapshot withEvent:event];
    }
}
- (void)isCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self weekViewIsCatchingSnapshot:snapshot];
    }
}
- (void)endCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self weekViewEndCatchingSnapshot:snapshot];
    }
}

//did finish
- (void)didCatchSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self weekViewDidCatchSnapshot:snapshot withEvent:event];
    }
}
- (void)removeOwnSprite:(UIView *)sprite
{
    if ([sprite isKindOfClass:[GEventView class]])
    {
        [self weekViewRemoveOwnEventView:(GEventView *)sprite];
    }
}

#pragma mark Called By Catcher
//prepare
- (GMoveSnapshot *)weekViewPrepareSnapshotForOwnEventView:(GEventView *)eventView
{
    GMoveSnapshot *snapshot = [[GMoveSnapshot alloc] initWithFrame:eventView.frame];
    [snapshot addSubviewToFill:eventView];
    [snapshot becomeCatchableInCalendarWithEvent:eventView.event];
    snapshot.alpha = 0.7;
    return snapshot;
}
- (CGRect)weekViewPrepareFrameForSnapshot:(GMoveSnapshot *)snapshot
{
    CGPoint snapshotCenter = [self convertPoint:snapshot.center fromView:snapshot.superview];
    NSInteger dayPosition = [self dayPositionOfPoint:snapshotCenter];
    CGRect eventFrame = [self frameForEvent: [snapshot.userInfo valueForKey:kGEvent]
                              atDayPosition: dayPosition];
    return [snapshot.superview convertRect:eventFrame fromView:self.scrollView];
}
- (void)weekViewDidPrepareSnapshot:(GMoveSnapshot *)snapshot
{
    CGPoint snapshotCenter = [self convertPoint:snapshot.center fromView:snapshot.superview];
    NSInteger dayPosition = [self dayPositionOfPoint:snapshotCenter];
    CGRect eventRect = GRectAddPoint([self convertRect:snapshot.frame fromView:snapshot.superview],
                                     self.scrollView.contentOffset);
    [self layoutEventViewsFromBeginY: CGRectGetMinY(eventRect)
                              toEndY: CGRectGetMaxY(eventRect)
                       atDayPosition: dayPosition
                            animated: YES];
    
}

//moving event
- (void)weekViewBeginCatchingSnapshot:(GMoveSnapshot *)snapshot withEvent:(GEvent *)event
{
    CGPoint snapshotCenter = [self convertPoint:snapshot.center fromView:snapshot.superview];
    NSInteger dayPosition = [self dayPositionOfPoint:snapshotCenter];

    GEventView *movingEventView = [self eventViewForEvent:event atDayPosition:dayPosition];
    if (movingEventView) {
        
        _snapshotAlpha = snapshot.alpha;
        snapshot.alpha = 0.0;
        
        movingEventView.alpha = 0.7;
        movingEventView.center = [self.scrollView convertPoint: snapshot.center
                                                      fromView: snapshot.superview];
        
        
        [self addSubview:movingEventView];
        
        self.movingEventView = movingEventView;
    }
}
- (void)weekViewIsCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    if (self.movingEventView)
    {
        self.movingEventView.center = [self convertPoint:snapshot.center fromView:snapshot.superview];
        
        CGRect rect = self.movingEventView.frame;
        
        if (CGRectGetMaxY(rect)>CGRectGetMaxY(self.scrollView.frame)) {
            [self.scrollView startAutoScrollToBottom];
        }else if (CGRectGetMinY(rect)<CGRectGetMinY(self.scrollView.frame)) {
            [self.scrollView startAutoScrollToTop];
        }else {
            [self.scrollView stopAutoScroll];
        }
    }
}
- (void)weekViewEndCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    if (self.movingEventView)
    {
        snapshot.alpha = _snapshotAlpha;
        
        [self.scrollView stopAutoScroll];
        [self.movingEventView removeFromSuperview];
    }
}

//did finish
- (void)weekViewDidCatchSnapshot:(GMoveSnapshot *)snapshot withEvent:(GEvent *)event
{
    CGPoint snapshotCenter = [self convertPoint:snapshot.center fromView:snapshot.superview];
    NSInteger dayPosition = [self dayPositionOfPoint:snapshotCenter];
    
    if (self.movingEventView)
    {
        [self.scrollView stopAutoScroll];
        
        CGRect eventRect = GRectAddPoint(self.movingEventView.frame, self.scrollView.contentOffset);
        
        event.beginTime = [self dateForOffset:CGRectGetMinY(eventRect) atDayPosition:dayPosition];
        event.endTime = [self dateForOffset:CGRectGetMaxY(eventRect) atDayPosition:dayPosition];
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(weekView:didUpdateEvent:)]) {
            [_delegate weekView:self didUpdateEvent:event];
        }
        
        [self.movingEventView removeFromSuperview];
    }
    
    if (event)
    {
        [self layoutEvent:event atDayPosition:dayPosition];
    }
}

- (void)weekViewRemoveOwnEventView:(GEventView *)eventView
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(weekView:didRemoveEvent:)]) {
        [_delegate weekView:self didRemoveEvent:eventView.event];
    }
    
    
    if (self.movingEventView)
    {
        [self.scrollView stopAutoScroll];
        [self.movingEventView removeFromSuperview];
    }
}


@end
