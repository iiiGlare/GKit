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
<GDayViewDataSource, GDayViewDelegate>

@property (nonatomic, weak) GDayView *dayView;
@property (nonatomic, weak) GWeekView *weekView;
@property (nonatomic, weak) GMonthView *monthView;

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"日",@"周",@"月"]];
    [segmentedControl setWidth:200];
    segmentedControl.center = self.topView.innerCenter;
    [segmentedControl addTarget:self action:@selector(changeCalenderType:) forControlEvents:UIControlEventValueChanged];
    [self.topView addSubview:segmentedControl];
    [segmentedControl setSelectedSegmentIndex:0];
    [self changeCalenderType:segmentedControl];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Action
- (void)changeCalenderType:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex==0) {
        [self.weekView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        GDayView *dayView = [[GDayView alloc] init];
        dayView.dataSource = self;
        dayView.delegate = self;
        [self.contentView addSubviewToFill:dayView];
        self.dayView = dayView;
    }else if (control.selectedSegmentIndex==1) {
        [self.dayView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        GWeekView *weekView = [[GWeekView alloc] init];
        [self.contentView addSubviewToFill:weekView];
        self.weekView = weekView;
    }else {
        [self.dayView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        GMonthView *monthView = [[GMonthView alloc] init];
        [self.contentView addSubview:monthView];
        self.monthView = monthView;
    }
}

#pragma mark - GDayViewDatasource / Delegate
- (NSArray *)dayView:(GDayView *)dayView eventsForDate:(NSDate *)date
{
    NSMutableArray *events = [NSMutableArray array];
    
    //-03:00 to 01:00
    GEvent *event = [[GEvent alloc] init];
    event.title = @"test -03:00 to 01:00";
    event.beginDate = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];
    
    // 21:00 to 25:00
    event = [[GEvent alloc] init];
    event.title = @"test 21:00 to 25:00";
    event.beginDate = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: [dayView.date nextDayBeginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: [dayView.date nextDayBeginPoint]];
    [events addObject:event];
    
    //08:00 to 11:30
    event = [[GEvent alloc] init];
    event.title = @"test 08:00 to 11:30";
    event.beginDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(8)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(11.5)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];
    
    //10:00 to 12:00
    event = [[GEvent alloc] init];
    event.title = @"test 10:00 to 12:00";
    event.beginDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(10)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(12)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];
    
    
    //13:00 to 18:00
    event = [[GEvent alloc] init];
    event.title = @"test 13:00 to 18:00";
    event.beginDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(13)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(18)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];
    
    return events;
}

- (void)dayView:(GDayView *)dayView didSelectEvent:(GEvent *)event
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

