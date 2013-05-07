//
//  CalendarViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-24.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "CalendarViewController.h"
#import "GCore.h"
#import "GMove.h"
#import "GCalendar.h"
#import "GNavigationViewController.h"

@interface CalendarViewController ()
<GDayViewDataSource, GDayViewDelegate,
 GWeekViewDataSource, GWeekViewDelegate>

@property (nonatomic, strong) GDayView *dayView;
@property (nonatomic, strong) GWeekView *weekView;
@property (nonatomic, strong) GMonthView *monthView;

@end

@implementation CalendarViewController

- (void)customInitialize
{
    
}

- (void)loadView
{
    self.view = [[GMoveScene alloc] initWithFrame:GScreenBounds()];
    self.view.autoresizingMask = GViewAutoresizingFlexibleSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTopViewHeight:60];
    [self.topView setBackgroundColor:[UIColor randomColor]];
    
    [self setBottomViewHeight:60];
    [self.bottomView setBackgroundColor:[UIColor randomColor]];
    
    self.dayView = [[GDayView alloc] initWithFrame:self.contentView.bounds];
    self.weekView = [[GWeekView alloc] initWithFrame:self.contentView.bounds];
    self.weekView.firstWeekday = GWeekdayTypeMonday;
    self.monthView = [[GMonthView alloc] initWithFrame:self.contentView.bounds];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"日",@"周",@"月"]];
    [segmentedControl setWidth:200];
    segmentedControl.center = self.topView.innerCenter;
    [segmentedControl addTarget:self action:@selector(changeCalenderType:) forControlEvents:UIControlEventValueChanged];
    [self.topView addSubview:segmentedControl];
    [segmentedControl setSelectedSegmentIndex:0];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeCalenderType:[[self.topView subviews] objectAtIndex:0]];
}

#pragma mark - Action
- (void)changeCalenderType:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex==0) {
        [self.weekView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        self.dayView.dataSource = self;
        self.dayView.delegate = self;
        [self.contentView addSubviewToFill:self.dayView];
        [self.dayView jumpToToday];
        
    }else if (control.selectedSegmentIndex==1) {
        [self.dayView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        self.weekView.dataSource = self;
        self.weekView.delegate = self;
        [self.contentView addSubviewToFill:self.weekView];
        [self.weekView jumpToToday];

    }else {
        [self.dayView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        [self.contentView addSubview:self.monthView];
    }
}

#pragma mark - GDayViewDatasource / Delegate
- (NSArray *)eventsForDayView:(GDayView *)dayView
{
    NSMutableArray *events = [NSMutableArray array];
    
    //-03:00 to 01:00
    GEvent *event = [[GEvent alloc] init];
    event.title = @"test -03:00 to 01:00";
    event.beginTime = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    // 21:00 to 25:00
    event = [[GEvent alloc] init];
    event.title = @"test 21:00 to 25:00";
    event.beginTime = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: dayView.nextDay];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: dayView.nextDay];
    [events addObject:event];
    
    //08:00 to 11:30
    event = [[GEvent alloc] init];
    event.title = @"test 08:00 to 11:30";
    event.beginTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(8)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(11.5)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    //10:00 to 12:00
    event = [[GEvent alloc] init];
    event.title = @"test 10:00 to 12:00";
    event.beginTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(10)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(12)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    
    //13:00 to 18:00
    event = [[GEvent alloc] init];
    event.title = @"test 13:00 to 18:00";
    event.beginTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(13)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(18)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    return events;
}

- (void)dayView:(GDayView *)dayView didSelectEvent:(GEvent *)event
{
    GViewController *eventVC = [GViewController new];
    eventVC.title = event.title;
    [self.navigationController pushViewController:eventVC animated:YES];
}

#pragma mark - GWeekView
- (NSArray *)eventsForWeekView:(GWeekView *)weekView
{
    NSMutableArray *events = [NSMutableArray array];

    GEvent *event = [[GEvent alloc] init];
    event.title = @"0 03:00 to 0 10:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(3)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(10)];
    [events addObject:event];
    
    event = [[GEvent alloc] init];
    event.title = @"0 21:00 to 1 05:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(21)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(5+GHoursInDay)];
    [events addObject:event];
    
    event = [[GEvent alloc] init];
    event.title = @"3 08:00 to 3 11:30";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(8+GHoursInDay*3)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(11.5+GHoursInDay*3)];
    [events addObject:event];
    
    event = [[GEvent alloc] init];
    event.title = @"3 10:00 to 3 12:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(10+GHoursInDay*3)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(12+GHoursInDay*3)];
    [events addObject:event];
    
    
    event = [[GEvent alloc] init];
    event.title = @"5 00:00 to 6 24:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(0+GHoursInDay*5)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(24+GHoursInDay*6)];
    [events addObject:event];
    
    return events;
}

- (void)weekView:(GDayView *)dayView didSelectEvent:(GEvent *)event
{
    GViewController *eventVC = [GViewController new];
    eventVC.title = event.title;
    [self.navigationController pushViewController:eventVC animated:YES];
}


#pragma mark - GMove
- (void)didPrepareSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [[GEvent alloc] init];
    [snapshot becomeCatchableInCalendarWithEvent:event];
}
@end

