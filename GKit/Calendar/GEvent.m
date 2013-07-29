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
        
        self.userObject = nil;
        
        NSDate *date = [NSDate date];
        self.beginTime = MIN(date, [[date beginningOfDay] dateByAddingTimeInterval:GTimeIntervalFromHours(23)]);
        self.endTime = [_beginTime dateByAddingTimeInterval:GTimeIntervalFromHours(1)];
        self.title = GLocalizedString(@"New Event");
        
        self.backgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor blackColor];
        self.foregroundColor = [UIColor blackColor];
    }
    return self;
}

@end
