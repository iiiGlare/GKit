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

@interface CalendarViewController ()
<GDayViewDataSource, GDayViewDelegate,
GMoveSpriteCatcherProtocol>

@property (nonatomic, weak) GDayView *dayView;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTopViewHeight:60];
    [self.topView setBackgroundColor:[UIColor randomColor]];
    
    GEventView *outEventView = [[GEventView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    outEventView.center = [self.topView innerCenter];
    [self.topView addSubview:outEventView];
    
    
    
    [self setBottomViewHeight:60];
    [self.bottomView setBackgroundColor:[UIColor randomColor]];
    
    GDayView *dayView = [[GDayView alloc] init];
    dayView.dataSource = self;
    dayView.delegate = self;
    [self.contentView addSubviewToFill:dayView];
    self.dayView = dayView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

