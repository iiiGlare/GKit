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
#import "GMoveSnapshot+GCalendar.h"

#pragma mark - GDayGridView
@interface GDayGridView : UIView
@property (nonatomic, assign) CGFloat gridLineTopMargin;
@property (nonatomic, assign) CGFloat gridLineBottomMargin;
@end
@implementation GDayGridView
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat hourHeight = (rect.size.height-_gridLineTopMargin-_gridLineBottomMargin)/GHoursInDay;
    CGFloat width = rect.size.width;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
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
    for (NSInteger i=0; i<GHoursInDay+1; i++) {
        CGFloat y = (i+0.5)*hourHeight+_gridLineTopMargin;
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, width, y);
    }
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
<UIScrollViewDelegate>

//layout
@property (nonatomic, assign) CGFloat gridHeight;
@property (nonatomic, assign) CGFloat gridTopMargin;
@property (nonatomic, assign) CGFloat gridBottomMargin;
@property (nonatomic, assign) CGFloat gridLineTopMargin;
@property (nonatomic, assign) CGFloat gridLineBottomMargin;

@property (nonatomic, assign) CGFloat hourViewWidth;
@property (nonatomic, assign) CGFloat hourHeight;

//
@property (nonatomic, assign) CGFloat dayEventViewWidth;
@property (nonatomic, assign) CGFloat dayBeginTimeOffset;
@property (nonatomic, assign) CGFloat dayEndTimeOffset;


//subviews
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GDayGridView *dayGridView;
@property (nonatomic, strong) GDayHourView *dayHourView;

//move
@property (nonatomic, weak) GEventView *movingEventView;
@property (nonatomic, assign) CGFloat snapshotAlpha;

//Time Indicator
@property (nonatomic, strong) NSTimer * timeIndicatorTimer;

@end

@implementation GDayView

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
    _gridTopMargin = 15.0;
    _gridBottomMargin = 15.0;
    _gridLineTopMargin = 1.0;
    _gridLineBottomMargin = 1.0;
    _gridHeight = GHoursInDay * _hourHeight + _gridLineTopMargin + _gridLineBottomMargin;
    
    //time indicator
    _timeIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    _timeIndicator.backgroundColor = [UIColor greenColor];
    
    //Tap Gesture
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGR];
}

- (void)didMoveToSuperview
{
    if (_scrollView==nil)
    {
        [self.scrollView addSubview:self.dayGridView];
        [self.scrollView addSubview:self.dayHourView];
        [self addSubview:self.scrollView];
    }
}

#pragma mark Setter / Getter
- (UIScrollView *)scrollView
{
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = GViewAutoresizingFlexibleSize;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (GDayGridView *)dayGridView
{
    if (_dayGridView==nil) {
        _dayGridView = [[GDayGridView alloc] initWithFrame:CGRectMake(0, _gridTopMargin, _scrollView.width, _gridHeight)];
        _dayGridView.backgroundColor = [UIColor whiteColor];
        _dayGridView.gridLineTopMargin = _gridLineTopMargin;
        _dayGridView.gridLineBottomMargin = _gridLineBottomMargin;
    }
    return _dayGridView;
}

- (GDayHourView *)dayHourView
{
    if (_dayHourView==nil) {
        _dayHourView = [[GDayHourView alloc] initWithFrame:CGRectMake(0, 0, _hourViewWidth, _scrollView.contentSize.height)];
        _dayHourView.backgroundColor = [UIColor whiteColor];
        _dayHourView.startCenterY = _gridTopMargin + _gridLineTopMargin;
        _dayHourView.endCenterY = _gridTopMargin + _gridHeight - _gridLineBottomMargin;
    }
    return _dayHourView;
}

- (void)setDay:(NSDate *)day
{
    _day = [day beginningOfDay];
    _nextDay = [_day dateByAddingTimeInterval:GTimeIntervalFromDays(1)];
    _previousDay = [_day dateByAddingTimeInterval:-GTimeIntervalFromDays(1)];
}

#pragma mark Action

- (void)jumpToToday
{
    NSDate *beginningOfToday = [[NSDate date] beginningOfDay];
    
    if ([self.day isEqualToDate:beginningOfToday]) return;
    
    self.day = beginningOfToday;
    [self reloadData];
}

- (void)goToNextDay
{
    self.day = self.nextDay;
    [self reloadData];
}

- (void)backToPreviousDay
{
    self.day = self.previousDay;
    [self reloadData];
}

- (void)reloadData
{
    //remove all event views
    [self.scrollView removeAllSubviewOfClass:[GEventView class]];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _gridHeight+_gridTopMargin+_gridBottomMargin);
    _dayEventViewWidth = [_scrollView contentSize].width - _hourViewWidth;
    _dayBeginTimeOffset = _gridTopMargin + _gridLineTopMargin;
    _dayEndTimeOffset = _hourHeight*GHoursInDay + _dayBeginTimeOffset;

    
    //show events
    if (_dataSource &&
        [_dataSource respondsToSelector:@selector(eventsForDayView:)])
    {
        NSArray *events = [_dataSource eventsForDayView:self];
        for (GEvent *event in events)
        {
            [self layoutGEvent:event];
        }
    }
    
    //show time indicator
    
    [self.timeIndicatorTimer invalidate];
    self.timeIndicatorTimer = nil;

    if ([self layoutTimeIndicator]) {
        
        self.timeIndicatorTimer = [NSTimer scheduledTimerWithTimeInterval: GTimeIntervalFromMinitues(1)
                                                                   target: self
                                                                 selector: @selector(layoutTimeIndicator)
                                                                 userInfo: nil
                                                                  repeats: YES];
        CGFloat offsetY = MAX(0, self.timeIndicator.center.y-10);
        offsetY = MIN(offsetY, self.scrollView.contentSize.height-self.scrollView.height);
        [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        
    }
}

#pragma mark Layout
- (BOOL)layoutTimeIndicator {
    
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:self.day];
    
    if (timeInterval >= 0 &&
        timeInterval <= GTimeIntervalFromDays(21)) {
        
        _timeIndicator.center = CGPointMake(self.scrollView.innerCenter.x, [self offsetForDate:now]);
        if (_timeIndicator.superview == nil) {
            _timeIndicator.width = self.scrollView.width;    
            [self.scrollView addSubview:_timeIndicator];
        }
        
        
        return YES;
    } else {
        
        [_timeIndicator removeFromSuperview];
        return NO;
    }
}

- (void)layoutGEvent:(GEvent *)event
{    
    GEventView *eventView = [self eventViewForGEvent:event];
    if (eventView)
    {    
        [_scrollView addSubview:eventView];
        
        [self layoutEventViewsFromBeginY: eventView.y
                                  toEndY: eventView.y + eventView.height
                                animated: NO];
    }
}

- (void)layoutEventViewsFromBeginY:(CGFloat)beginY toEndY:(CGFloat)endY animated:(BOOL)animated
{
    //
    NSMutableArray *sameTimeViews = [NSMutableArray array];
    for (UIView *view in [_scrollView subviews]) {
        if ([view isKindOfClass:[GEventView class]]) {
            CGFloat viewBeginY = CGRectGetMinY(view.frame);
            CGFloat viewEndY = CGRectGetMaxY(view.frame);
            if (!(viewEndY<=beginY || viewBeginY>=endY)) {
                [sameTimeViews addObject:view];
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
        CGFloat x = _hourViewWidth + i*eventViewWidth;
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

#pragma mark Utils
- (GEventView *)eventViewForGEvent:(GEvent *)event
{
    CGRect frame = [self frameForGEvent:event];
    if (CGRectEqualToRect(frame, CGRectZero)) return nil;
    
    GEventView *eventView = nil;
    if (_dataSource &&
        [_dataSource respondsToSelector:@selector(dayView:eventViewForGEvent:)])
    {
        eventView = [_dataSource dayView:self eventViewForGEvent:event];
    }
    if (eventView==nil)
    {
        eventView = [[GEventView alloc] init];
		eventView.backgroundColor = GRandomColorWithAlpha(0.5);
    }
    
    eventView.event = event;
    eventView.frame = frame;
    
    return eventView;
}


- (CGRect)frameForGEvent:(GEvent *)event
{
    if (![self canShowGEvent:event]) return CGRectZero;
    
    //
    NSTimeInterval beginTimeInterval = [event.beginTime timeIntervalSinceDate:self.day];
    NSTimeInterval endTimeInterval = [event.endTime timeIntervalSinceDate:self.day];

    CGFloat beginY = _hourHeight * beginTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineTopMargin;
    CGFloat endY = _hourHeight * endTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineTopMargin;
    
    return CGRectMake(_hourViewWidth, beginY, _dayEventViewWidth, endY-beginY);
}

- (BOOL)canShowGEvent:(GEvent *)event
{
    NSDate *beginTime = event.beginTime;
    NSDate *endTime = event.endTime;
        
    if ([beginTime compare:self.nextDay]!=NSOrderedAscending ||
        [endTime compare:self.day]!=NSOrderedDescending)
    {
        return NO;
    }
    
    return YES;
}

- (NSDate *)dateForOffset:(CGFloat)offset
{    
    CGFloat dayBeginOffset = _gridTopMargin + _gridLineTopMargin;
    NSTimeInterval interval = gfloor(((offset-dayBeginOffset)/self.hourHeight)*GTimeIntervalFromHours(1));
    return [NSDate dateWithTimeInterval:interval sinceDate:self.day];
}

- (CGFloat)offsetForDate:(NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSinceDate:self.day];
    CGFloat dayBeginOffset = _gridTopMargin + _gridLineTopMargin;
    return gfloor(interval * self.hourHeight/GTimeIntervalFromHours(1)) + dayBeginOffset;
}

#pragma mark Gesture Recognizer
- (void)handleTap:(UITapGestureRecognizer *)tapGR
{
    CGPoint location = [tapGR locationInView:self];
    UIView *view = [self hitTest:[tapGR locationInView:self] withEvent:nil];
    if (view && [view isKindOfClass:[GEventView class]])
    {
        if (_delegate &&
            [_delegate respondsToSelector:@selector(dayView:didSelectGEvent:)])
        {
            [_delegate dayView:self didSelectGEvent:[(GEventView *)view event]];
        }
    }else {
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(dayView:requireGEventAtDate:)])
        {
            CGFloat offset = [self.scrollView convertPoint:location fromView:self].y;
            [_delegate dayView:self requireGEventAtDate:[self dateForOffset:offset]];
        }
        
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark GMoveSpriteCatcherProtocol
//preprare
- (GMoveSnapshot *)prepareSnapshotForOwnSprite:(UIView *)sprite
{
    if ([sprite isKindOfClass:[GEventView class]]) {
        return [self dayViewPrepareSnapshotForOwnEventView:(GEventView *)sprite];
    }else{
        return nil;
    }
    
}
- (CGRect)prepareFrameForSnapshot:(GMoveSnapshot *)snapshot
{
    if ([snapshot.sprite isKindOfClass:[GEventView class]]) {
        return [self dayViewPrepareFrameForSnapshot:snapshot];
    }else{
        return snapshot.frame;
    }
}
- (void)didPrepareSnapshot:(GMoveSnapshot *)snapshot
{
    if ([snapshot.sprite isKindOfClass:[GEventView class]]) {
        [self dayViewDidPrepareSnapshot:snapshot];
    }
}

//moving snapshot
- (void)beginCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self dayViewBeginCatchingSnapshot:snapshot withGEvent:event];
    }
}
- (void)isCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self dayViewIsCatchingSnapshot:snapshot];
    }
}
- (void)endCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self dayViewEndCatchingSnapshot:snapshot];
    }
}

//did finish
- (void)didCatchSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    if (event)
    {
        [self dayViewDidCatchSnapshot:snapshot withGEvent:event];
    }
}
- (void)removeOwnSprite:(UIView *)sprite
{
    if ([sprite isKindOfClass:[GEventView class]])
    {
        [self dayViewRemoveOwnEventView:(GEventView *)sprite];
    }
}

#pragma mark Called By Catcher
//prepare
- (GMoveSnapshot *)dayViewPrepareSnapshotForOwnEventView:(GEventView *)eventView
{
    GMoveSnapshot *snapshot = [[GMoveSnapshot alloc] initWithFrame:eventView.frame];
	eventView.backgroundColor = [UIColor orangeColor];
    [snapshot addSubviewToFill:eventView];
    [snapshot becomeCatchableInCalendarWithGEvent:eventView.event];
    snapshot.alpha = 0.7;
    return snapshot;
}
- (CGRect)dayViewPrepareFrameForSnapshot:(GMoveSnapshot *)snapshot
{
    CGRect eventFrame = [self frameForGEvent: [snapshot.userInfo valueForKey:kGEvent]];
    return [snapshot.superview convertRect:eventFrame fromView:self.scrollView];
}
- (void)dayViewDidPrepareSnapshot:(GMoveSnapshot *)snapshot
{
    CGRect eventRect = GRectAddPoint([self convertRect:snapshot.frame fromView:snapshot.superview],
                                     self.scrollView.contentOffset);
    [self layoutEventViewsFromBeginY: CGRectGetMinY(eventRect)
                              toEndY: CGRectGetMaxY(eventRect)
                            animated: YES];
    
}

//moving event
- (void)dayViewBeginCatchingSnapshot:(GMoveSnapshot *)snapshot withGEvent:(GEvent *)event
{
    GEventView *movingEventView = [self eventViewForGEvent:event];
    if (movingEventView) {
        
        _snapshotAlpha = snapshot.alpha;
        snapshot.alpha = 0.0;
        
		movingEventView.backgroundColor = [UIColor orangeColor];
        movingEventView.alpha = 0.7;
        movingEventView.center = [self.scrollView convertPoint: snapshot.center
                                                      fromView: snapshot.superview];
        
        
        [self addSubview:movingEventView];
        
        self.movingEventView = movingEventView;
    }
}
- (void)dayViewIsCatchingSnapshot:(GMoveSnapshot *)snapshot
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
- (void)dayViewEndCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    if (self.movingEventView)
    {
        snapshot.alpha = _snapshotAlpha;
        
        [self.scrollView stopAutoScroll];
        [self.movingEventView removeFromSuperview];
    }
}

//did finish
- (void)dayViewDidCatchSnapshot:(GMoveSnapshot *)snapshot withGEvent:(GEvent *)event
{
    
    if (self.movingEventView)
    {
        [self.scrollView stopAutoScroll];

        CGRect eventRect = GRectAddPoint(self.movingEventView.frame, self.scrollView.contentOffset);
        if (!(CGRectGetMaxY(eventRect)<_gridTopMargin+_gridLineTopMargin) &&
            !(CGRectGetMinY(eventRect)>_gridTopMargin+_gridHeight-_gridLineBottomMargin))
        {
            event.beginTime = [self dateForOffset:CGRectGetMinY(eventRect)];
            event.endTime = [self dateForOffset:CGRectGetMaxY(eventRect)];
            
            if (_delegate &&
                [_delegate respondsToSelector:@selector(dayView:didUpdateGEvent:)]) {
                [_delegate dayView:self didUpdateGEvent:event];
            }
        }
        
        [self.movingEventView removeFromSuperview];
    }
    
    if (event)
    {
        [self layoutGEvent:event];
    }
}

- (void)dayViewRemoveOwnEventView:(GEventView *)eventView
{    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(dayView:didRemoveGEvent:)]) {
        [_delegate dayView:self didRemoveGEvent:eventView.event];
    }
    
    
    if (self.movingEventView)
    {
        [self.scrollView stopAutoScroll];
        [self.movingEventView removeFromSuperview];
    }
}


@end


