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
    
    CGFloat dayWidth = gfloor((self.width-_hourViewWidth)/GDaysInWeek);
    CGFloat height = self.height;
    
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
    
    
    CGFloat hourHeight = (self.height-_gridLineTopMargin-_gridLineBottomMargin)/GHoursInDay;
    CGFloat width = self.width;
    
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
@interface GWeekdayView ()
@property (nonatomic, assign) GWeekdayType firstWeekday;
@property (nonatomic, assign) CGFloat hourViewWidth;
@property (nonatomic, assign) CGFloat dayTitleBottomMargin;
@property (nonatomic, strong) NSDate *beginningOfWeek;
@end

@implementation GWeekdayView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _weekdayFont = [UIFont systemFontOfSize:12.0];
        _weekdayColor = [UIColor blackColor];
        
        _todayFont = [UIFont systemFontOfSize:12.0];
        _todayColor = [UIColor blueColor];
        
        NSMutableArray *weekdayLabels = [NSMutableArray arrayWithCapacity:GDaysInWeek];
        for (int i=0; i<GDaysInWeek; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
            label.textAlignmentG = GTextAlignmentCenter;
            label.font = _weekdayFont;
            label.textColor = _weekdayColor;
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            [weekdayLabels addObject:label];
        }
        _weekdayLabels = weekdayLabels;
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
    [self hightlightToday];
}

#pragma mark Setter
- (void)setWeekdayFont:(UIFont *)weekdayFont
{
    _weekdayFont = [weekdayFont copy];
    
    [self hightlightToday];
}
- (void)setWeekdayColor:(UIColor *)weekdayColor
{
    _weekdayColor = [weekdayColor copy];
    
    [self hightlightToday];
}
- (void)setTodayFont:(UIFont *)todayFont
{
    _todayFont = [todayFont copy];
    
    [self hightlightToday];
}
- (void)setTodayColor:(UIColor *)todayColor
{
    _todayColor = [todayColor copy];
    
    [self hightlightToday];
}
- (void)setBeginningOfWeek:(NSDate *)beginningOfWeek
{
    _beginningOfWeek = beginningOfWeek;
    
    [self hightlightToday];
}
#pragma mark Weekdaylabels
- (void)hightlightToday
{
    for (UILabel *label in self.weekdayLabels){
        label.textColor = _weekdayColor;
        label.font = _weekdayFont;
    }
    
    NSDate *today = [NSDate date];
    NSTimeInterval timeInterval = [today timeIntervalSinceDate:_beginningOfWeek];
    if (timeInterval>=0 && timeInterval<GTimeIntervalFromDays(GDaysInWeek))
    {
        UILabel *todayLabel = [self weekdayLabelForWeekday:[today weekday]];
        todayLabel.textColor = _todayColor;
        todayLabel.font = _todayFont;
    }
}
- (UILabel *)weekdayLabelForWeekday:(GWeekdayType)weekdayType
{
    return [self.weekdayLabels objectAtCirclePosition:weekdayType-_firstWeekday];
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
        [self.scrollView addSubview:self.weekHourView];
        [self addSubview:self.scrollView];
        
        [self addSubview:self.weekdayView];
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
                        CGRectMake(0, 0, _scrollView.width, _dayViewHeight)];
        _weekdayView.backgroundColor = [UIColor whiteColor];
        _weekdayView.hourViewWidth = _hourViewWidth;
        _weekdayView.dayTitleBottomMargin = _dayTitleBottomMargin;
        _weekdayView.firstWeekday = _firstWeekday;
        _weekdayView.beginningOfWeek = _beginningOfWeek;
    }
    return _weekdayView;
}

- (void)setDay:(NSDate *)day
{
    _day = [day beginningOfDay];
    _beginningOfWeek = [day beginningOfWeekWithFirstWeekday:_firstWeekday];
    _endingOfWeek = [_beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(7)];
    
    //WeekdayView
    _weekdayView.beginningOfWeek = _beginningOfWeek;
}

- (void)setFirstWeekday:(GWeekdayType)firstWeekday
{
    _firstWeekday = firstWeekday;
    _beginningOfWeek = [_day beginningOfWeekWithFirstWeekday:_firstWeekday];
    _endingOfWeek = [_beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(7)];
    
    //WeekdayView
    _weekdayView.beginningOfWeek = _beginningOfWeek;
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
        [_dataSource respondsToSelector:@selector(eventsForWeekView:)])
    {
        NSArray *events = [_dataSource eventsForWeekView:self];
        
        for (GEvent *event in events) {
            [self layoutGEvent:event];
        }        
    }
}

#pragma mark Layout
- (void)layoutGEvent:(GEvent *)event
{
    NSArray *eventViews = [self eventViewsForGEvent:event];
    
    for (GEventView *eventView in eventViews)
    {
        [_scrollView addSubview:eventView];
        
//        [self layoutEventViewsFromBeginY: eventView.y
//                                  toEndY: eventView.y + eventView.height
//                           atDayPosition: [self dayPositionForDate:eventView.beginTime]
//                                animated: NO];
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

- (NSArray *)eventViewsForGEvent:(GEvent *)event
{
    NSMutableArray *eventViews = [NSMutableArray array];
    
    //BeginTime
    NSDate *beginTime = event.beginTime;
    if ([beginTime compare:_beginningOfWeek]==NSOrderedAscending) beginTime = _beginningOfWeek;
    
    //EndTime
    NSDate *endTime = event.endTime;
    if ([endTime compare:_endingOfWeek]==NSOrderedDescending) endTime = _endingOfWeek;
    
    //Check BeginTime and EndTime first
    if ([beginTime compare:endTime]!=NSOrderedAscending) return nil;

    NSDate *eventViewBeginTime = beginTime;
    NSDate *eventViewEndTime;
    
	UIColor *color = GRandomColorWithAlpha(0.5);
	
    do {
        
        eventViewEndTime = [[eventViewBeginTime beginningOfDay] dateByAddingTimeInterval:GTimeIntervalFromHours(GHoursInDay)];
        eventViewEndTime = ([eventViewEndTime compare:endTime]==NSOrderedAscending)?eventViewEndTime:endTime;
        
        CGRect frame = [self frameForBeginTime: eventViewBeginTime
                                       endTime: eventViewEndTime
                                 atDayPosition: [self dayPositionForDate:eventViewBeginTime]];
        
        GEventView *eventView = [[GEventView alloc] initWithFrame:frame];
		eventView.backgroundColor = color;
        eventView.event = event;
        eventView.beginTime = eventViewBeginTime;
        eventView.endTime = eventViewEndTime;
        
        [eventViews addObject:eventView];
        
        eventViewBeginTime = eventViewEndTime;
        
    } while ([eventViewBeginTime compare:endTime]==NSOrderedAscending);
    
    return eventViews;
}

- (CGRect)frameForBeginTime:(NSDate *)beginTime endTime:(NSDate *)endTime atDayPosition:(NSInteger)dayPosition
{
    NSDate *dayBeginPoint = [self.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(dayPosition)];
    
    //
    NSTimeInterval beginTimeInterval = [beginTime timeIntervalSinceDate:dayBeginPoint];
    NSTimeInterval endTimeInterval = [endTime timeIntervalSinceDate:dayBeginPoint];
    
    CGFloat beginY = _hourHeight * beginTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineTopMargin;
    CGFloat endY = _hourHeight * endTimeInterval/GTimeIntervalFromHours(1) + _gridTopMargin + _gridLineTopMargin;
    
    return CGRectMake(_hourViewWidth + _dayEventViewWidth*dayPosition, beginY,
                      _dayEventViewWidth, endY-beginY);
}

- (NSDate *)dateForOffset:(CGFloat)offset atDayPosition:(NSInteger)dayPosition
{
    NSTimeInterval interval = gfloor(((offset-_dayBeginTimeOffset)/self.hourHeight)*GTimeIntervalFromHours(1));
    return [NSDate dateWithTimeInterval:interval sinceDate:[self.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromDays(dayPosition)]];
}

- (NSInteger)dayPositionForPoint:(CGPoint)point
{
    return gfloor((point.x - _hourViewWidth)/_dayEventViewWidth);
}

- (NSInteger)dayPositionForDate:(NSDate *)date
{
    if ([date compare:_beginningOfWeek]!=NSOrderedDescending) return 0;
    if ([date compare:_endingOfWeek]!=NSOrderedAscending) return 6;
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:_beginningOfWeek];
    return gfloor(timeInterval/GTimeIntervalFromHours(GHoursInDay));
}


#pragma mark Gesture Recognizer
- (void)handleTap:(UITapGestureRecognizer *)tapGR
{
    CGPoint location = [tapGR locationInView:self];
    UIView *view = [self hitTest:location withEvent:nil];
    if (view && [view isKindOfClass:[GEventView class]])
    {
        if (_delegate &&
            [_delegate respondsToSelector:@selector(weekView:didSelectGEvent:)])
        {
            [_delegate weekView:self didSelectGEvent:[(GEventView *)view event]];
        }
    }else {
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(weekView:requireGEventAtDate:)])
        {
            CGPoint offsetPoint = [self.scrollView convertPoint:location fromView:self];
            NSInteger dayPosition = [self dayPositionForPoint:offsetPoint];
            NSDate *date = [self dateForOffset:offsetPoint.y atDayPosition:dayPosition];
            [_delegate weekView:self requireGEventAtDate:date];
        }
    }
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
        [self weekViewBeginCatchingSnapshot:snapshot withGEvent:event];
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
        [self weekViewDidCatchSnapshot:snapshot withGEvent:event];
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
	eventView.backgroundColor = [UIColor orangeColor];
    [snapshot addSubviewToFill:eventView];
    [snapshot becomeCatchableInCalendarWithGEvent:eventView.event];
    snapshot.alpha = 0.7;
    
    //remove all event views for event
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[GEventView class]] &&
            [[(GEventView *)view event] isEqual:eventView.event])
        {
            [view removeFromSuperview];
        }
    }
    
    return snapshot;
}
- (CGRect)weekViewPrepareFrameForSnapshot:(GMoveSnapshot *)snapshot
{
    CGPoint snapshotCenter = [self convertPoint:snapshot.center fromView:snapshot.superview];
    NSInteger dayPosition = [self dayPositionForPoint:snapshotCenter];
    GEvent *event = [snapshot.userInfo valueForKey:kGEvent];
    CGRect eventFrame = [self frameForBeginTime: event.beginTime
                                        endTime: event.endTime
                                  atDayPosition: dayPosition];
    return [snapshot.superview convertRect:eventFrame fromView:self.scrollView];
}
- (void)weekViewDidPrepareSnapshot:(GMoveSnapshot *)snapshot
{
//    CGPoint snapshotCenter = [self convertPoint:snapshot.center fromView:snapshot.superview];
//    NSInteger dayPosition = [self dayPositionForPoint:snapshotCenter];
//    CGRect eventRect = GRectAddPoint([self convertRect:snapshot.frame fromView:snapshot.superview],
//                                     self.scrollView.contentOffset);
//    [self layoutEventViewsFromBeginY: CGRectGetMinY(eventRect)
//                              toEndY: CGRectGetMaxY(eventRect)
//                       atDayPosition: dayPosition
//                            animated: YES];
    
}

//moving event
- (void)weekViewBeginCatchingSnapshot:(GMoveSnapshot *)snapshot withGEvent:(GEvent *)event
{
    GEvent *tempEvent = [[GEvent alloc] init];
    tempEvent.title = event.title;
    tempEvent.beginTime = [self dateForOffset:0 atDayPosition:0];
    tempEvent.endTime = [tempEvent.beginTime dateByAddingTimeInterval:[event.endTime timeIntervalSinceDate:event.beginTime]];
    CGRect eventViewFrame = [self frameForBeginTime: tempEvent.beginTime
                                            endTime: tempEvent.endTime
                                      atDayPosition: 0];
    GEventView *movingEventView = [[GEventView alloc] initWithFrame:eventViewFrame];
	movingEventView.backgroundColor = [UIColor orangeColor];
	movingEventView.event = tempEvent;
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
- (void)weekViewDidCatchSnapshot:(GMoveSnapshot *)snapshot withGEvent:(GEvent *)event
{
    CGPoint snapshotCenter = [self convertPoint:snapshot.center fromView:snapshot.superview];
    NSInteger dayPosition = [self dayPositionForPoint:snapshotCenter];
    
    if (self.movingEventView)
    {
        [self.scrollView stopAutoScroll];
        
        CGRect eventRect = GRectAddPoint(self.movingEventView.frame, self.scrollView.contentOffset);
        if (!(CGRectGetMaxY(eventRect)<_gridTopMargin+_gridLineTopMargin) &&
            !(CGRectGetMinY(eventRect)>_gridTopMargin+_gridHeight-_gridLineBottomMargin))
        {
            event.beginTime = [self dateForOffset:CGRectGetMinY(eventRect) atDayPosition:dayPosition];
            event.endTime = [self dateForOffset:CGRectGetMaxY(eventRect) atDayPosition:dayPosition];
            
            if (_delegate &&
                [_delegate respondsToSelector:@selector(weekView:didUpdateGEvent:)])
            {
                [_delegate weekView:self didUpdateGEvent:event];
            }
        }
        
        [self.movingEventView removeFromSuperview];
    }
    
    if (event)
    {
        [self layoutGEvent:event];
    }
}

- (void)weekViewRemoveOwnEventView:(GEventView *)eventView
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(weekView:didRemoveGEvent:)]) {
        [_delegate weekView:self didRemoveGEvent:eventView.event];
    }
    
    
    if (self.movingEventView)
    {
        [self.scrollView stopAutoScroll];
        [self.movingEventView removeFromSuperview];
    }
}


@end
