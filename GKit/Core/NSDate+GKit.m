//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NSDate+GKit.h"
#import "GMath.h"
#import "GMacros.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
NSTimeInterval GTimeIntervalFromMinitues(NSUInteger minutes)
{
    return minutes * 60;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
NSTimeInterval GTimeIntervalFromHours(NSUInteger hours)
{
    return GTimeIntervalFromMinitues(hours * 60);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
NSTimeInterval GTimeIntervalFromDays(NSUInteger days)
{
    return GTimeIntervalFromHours(days * 24);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
NSTimeInterval GTimeIntervalFromWeeks(NSUInteger weeks)
{
    return GTimeIntervalFromDays(weeks * 7);
}

/////////////////////////////////////////////////////////////////
NSString * GTimerElementStringFormElement(NSUInteger element)
{
    return [NSString stringWithFormat:(element<10?@"0%d":@"%d"),element];
}
NSString * GTimerStringFromTimeInterval(NSTimeInterval timeInterval)
{
    NSUInteger min = gfloor(timeInterval/60);
	NSUInteger sec = gfloor(timeInterval-60*min);
	return [NSString stringWithFormat:@"%@:%@",
            GTimerElementStringFormElement(min),
            GTimerElementStringFormElement(sec)];
}

@implementation NSDate (GKit)

//string from date
- (NSString *)dateStringWithFormat:(NSString *)dateFormat
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormat];
	return [formatter stringFromDate:self];
}
//date from date
- (NSDate *)dateWithFormat:(NSString *)dateFormat
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormat];
	return [formatter dateFromString:[formatter stringFromDate:self]];
}
//hour string
- (NSString *)hourString
{
	return [self dateStringWithFormat:@"HH"];
}
//min string
- (NSString *)minuteString
{
	return [self dateStringWithFormat:@"mm"];
}

///////////////
- (NSDate *)beginPoint
{
    NSDateComponents *components = [GCurrentCalendar() components: GDateComponets
                                                         fromDate: self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [GCurrentCalendar() dateFromComponents:components];
}

- (NSDate *)previousDayBeginPoint
{
    NSDateComponents *components = [GCurrentCalendar() components: GDateComponets
                                                         fromDate: self];
    [components setDay:(components.day-1)];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [GCurrentCalendar() dateFromComponents:components];
}

- (NSDate *)nextDayBeginPoint
{
    NSDateComponents *components = [GCurrentCalendar() components: GDateComponets
                                                         fromDate: self];
    [components setDay:(components.day+1)];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [GCurrentCalendar() dateFromComponents:components];
}


@end
