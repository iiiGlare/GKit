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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Debugging Tools

/**
 * Only writes to the log when DEBUG is defined.
 */
#ifdef DEBUG
#define GPRINT(xx, ...) NSLog(@"***%s(%d)*** " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define GPRINT(xx, ...) ((void)0)
#endif // #ifdef DEBUG

/**
 * Log Separator
 */
#ifdef DEBUG
#define GPRINTSeparator(name) \
    NSLog(@"\n==================================================(%s(%d) %@)==================================================", \
        __PRETTY_FUNCTION__, __LINE__, name)
#else
#define GPRINTSeparator(name) ((void)0)
#endif // #ifdef DEBUG

/**
 * Log Method
 */
#ifdef DEBUG
#define GPRINTMethodName() GPRINT(@"@selector(%@)", NSStringFromSelector(_cmd))
#else
#define GPRINTMethodName() ((void)0)
#endif // #ifdef DEBUG

/**
 * Log Error when DEBUG is defined.
 */
#ifdef DEBUG
#define GPRINTError(error) GPRINT(@"Error: \n    Domain = %@, \n    Code = %d, \n    UserInfo = {%@}\n    -Description: %@\n    -FailureReason: %@\n    -RecoverySuggestion: %@\n    -RecoveryOptions: %@", \
    [error domain], \
    [error code], \
    [[[error userInfo] descriptionInStringsFileFormat] \
        stringByRemoveAllWhitespaceAndNewlineCharacters], \
    [error localizedDescription], \
    [error localizedFailureReason], \
    [error localizedRecoverySuggestion], \
    [error localizedRecoveryOptions])
#else
#define GPRINTError(error) ((void)0)
#endif // #ifdef DEBUG

/**
 * Assertions that only fire when DEBUG is defined.
 */
#ifdef DEBUG
#define GASSERT(xx) { if (!(xx)) { GPRINT(@"Assert Failed: %s", #xx); } \
                      else { GPRINT(@"Assert Succeed: %s", #xx); } } ((void)0)
#else
#define GASSERT(xx) ((void)0)
#endif // #ifdef DEBUG

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Suppress Warnings
#define GSuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#define GSuppressDeprecatedDeclarationWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SDK Availability
/**
 *     #if __IPHONE_OS_VERSION_MAX_ALLOWED >= G_IPHONE_5_0
 *       // This code will only compile on versions >= iOS 5.0
 *     #endif
 */

#define G_IPHONE_2_0     20000
#define G_IPHONE_2_1     20100
#define G_IPHONE_2_2     20200
#define G_IPHONE_3_0     30000
#define G_IPHONE_3_1     30100
#define G_IPHONE_3_2     30200
#define G_IPHONE_4_0     40000
#define G_IPHONE_4_1     40100
#define G_IPHONE_4_2     40200
#define G_IPHONE_4_3     40300
#define G_IPHONE_5_0     50000
#define G_IPHONE_5_1     50100
#define G_IPHONE_6_0     60000
#define G_IPHONE_6_1     60100
#define G_IPHONE_7_0     70000
#define G_IPHONE_NA      99999  /* not available */

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifndef G_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define G_INSTANCETYPE instancetype
#else
#define G_INSTANCETYPE id
#endif
#endif


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common Metrics

/**
 * UIView Autoresizing Mask
 */

#define GViewAutoresizingNone				UIViewAutoresizingNone
#define GViewAutoresizingFlexibleMargins	UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin
#define GViewAutoresizingFlexibleSize		UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
#define GViewAutoresizingFlexibleAll		GViewAutoresizingFlexibleMargins|GViewAutoresizingFlexibleSize

/**
 * UIView Layout
 */

//Screen
#define GScreenBounds()	[[UIScreen mainScreen] bounds]
#define GScreenWidth	[[UIScreen mainScreen] bounds].size.width
#define GScreenHeight	[[UIScreen mainScreen] bounds].size.height
#define GScreenScale    [[UIScreen mainScreen] scale]

//Status Bar
#define GStatusBarHeight	[[UIApplication sharedApplication] statusBarFrame].size.height

//Navigation Bar
#define GNavigationBarHeight	44.0f

//Tab Bar
#define GTabBarHeight			49.0f

//Tool Bar
#define GToolBarHeight          44.0f

//Picker
#define GPickerHeight           216.0f

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Localize

#define GLocalizedString(x, ...) NSLocalizedString(x, nil)

//Date
#define GDateComponents (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit)
#define GSecondsInMinute 60
#define GMinutesInHour 60
#define GHoursInDay 24
#define GDaysInWeek 7

