//
//  GEvent.m
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GEvent.h"
#import "GCore.h"

@implementation GEvent

- (id)init
{
    self = [super init];
    if (self) {
        NSDate *date = [NSDate date];
        self.beginDate = date;
        self.endDate = [date dateByAddingTimeInterval:GTimeIntervalFromHours(1)];
        self.title = GLocalizedString(@"New Event");
    }
    return self;
}

@end
