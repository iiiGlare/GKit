//
//  GMoveSnapshot+GCalendar.m
//  GKitDemo
//
//  Created by Glare on 13-4-24.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GMoveSnapshot+GCalendar.h"

@implementation GMoveSnapshot (GCalendar)

- (void)becomeCatchableInCalendarWithGEvent:(GEvent *)event
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo addEntriesFromDictionary:self.userInfo];
    [userInfo setValue:event forKey:kGEvent];
    self.userInfo = userInfo;
}

@end
