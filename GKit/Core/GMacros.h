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
#define GPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define GPRINT(xx, ...)  ((void)0)
#endif // #ifdef DEBUG

/**
 * Log Error when DEBUG is defined.
 */
#ifdef DEBUG
#define GPRINTError(error) GPRINT(@"error : %@, %@",error, [error userInfo])
#else
#define GPRINTError(error)  ((void)0)
#endif // #ifdef DEBUG

/**
 * Assertions that only fire when DEBUG is defined.
 */
#ifdef DEBUG
#define GASSERT(xx) { if (!(xx)) { GPRINT(@"GASSERT failed: %s", #xx); } } ((void)0)
#else
#define GASSERT(xx) ((void)0)
#endif // #ifdef DEBUG


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SDK Availability
/**
 *     #if __IPHONE_OS_VERSION_MAX_ALLOWED >= G_iOS_5_0
 *       // This code will only compile on versions >= iOS 5.0
 *     #endif
 */

#define G_iOS_5_0     50000
#define G_iOS_5_1     50100
#define G_iOS_6_0     60000
#define G_iOS_6_1     60100


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
#define GHoursInDay 24
#define GDaysInWeek 7

