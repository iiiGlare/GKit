//
//  HomeViewController.m
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "HomeViewController.h"
#import "GCore.h"
#import "GMove.h"
#import "GCalendar.h"

@interface HomeViewController ()
<GDayViewDataSource>
@end

@implementation HomeViewController

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
    
    [self setTopViewHeight:100];
    [self.topView setBackgroundColor:[UIColor randomColor]];
    [self setBottomViewHeight:100];
    [self.bottomView setBackgroundColor:[UIColor randomColor]];
        
    GDayView *dayView = [[GDayView alloc] init];
    dayView.dataSource = self;
    [self.contentView addSubviewToFill:dayView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (NSArray *)dayView:(GDayView *)dayView eventsForDate:(NSDate *)date
{
    NSMutableArray *events = [NSMutableArray array];
    
    //-03:00 to 01:00
    GEvent *event = [[GEvent alloc] init];
    event.title = @"test";
    event.beginDate = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];

    // 21:00 to 25:00
    event = [[GEvent alloc] init];
    event.title = @"test";
    event.beginDate = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: [dayView.date nextDayBeginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: [dayView.date nextDayBeginPoint]];
    [events addObject:event];
    
    //08:00 to 11:30
    event = [[GEvent alloc] init];
    event.title = @"test";
    event.beginDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(8)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(11.5)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];
    
    //10:00 to 12:00
    event = [[GEvent alloc] init];
    event.title = @"test";
    event.beginDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(10)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(12)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];
    
    
    //13:00 to 18:00
    event = [[GEvent alloc] init];
    event.title = @"test";
    event.beginDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(13)
                                         sinceDate: [dayView.date beginPoint]];
    event.endDate = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(18)
                                       sinceDate: [dayView.date beginPoint]];
    [events addObject:event];
    
    return events;
}
@end
