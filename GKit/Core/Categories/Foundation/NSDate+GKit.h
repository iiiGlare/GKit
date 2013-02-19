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

#import <Foundation/Foundation.h>

/**
 */
NSTimeInterval GTimeIntervalFromMinitues(NSUInteger minutes);
NSTimeInterval GTimeIntervalFromHours(NSUInteger hours);
NSTimeInterval GTimeIntervalFromDays(NSUInteger days);
NSTimeInterval GTimeIntervalFromWeeks(NSUInteger weeks);

/**
 Timer String 61:59
 */
NSString * GTimerElementStringFormElement(NSUInteger element);
NSString * GTimerStringFromTimeInterval(NSTimeInterval timeInterval);

@interface NSDate (GKit)

//string from date
- (NSString *)dateStringWithFormat:(NSString *)dateFormat;
//date from date
- (NSDate *)dateWithFormat:(NSString *)dateFormat;
//hour string
- (NSString *)hourString;
//min string
- (NSString *)minuteString;

@end
