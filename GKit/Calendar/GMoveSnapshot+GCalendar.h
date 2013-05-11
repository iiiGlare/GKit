//
//  GMoveSnapshot+GCalendar.h
//  GKitDemo
//
//  Created by Glare on 13-4-24.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GMoveSnapshot.h"
#import "GEvent.h"

@interface GMoveSnapshot (GCalendar)

- (void)becomeCatchableInCalendarWithGEvent:(GEvent *)event;

@end
