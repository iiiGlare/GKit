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

#import <UIKit/UIKit.h>

extern NSString * const GOSVersion_2_0;
extern NSString * const GOSVersion_2_1;
extern NSString * const GOSVersion_2_2;
extern NSString * const GOSVersion_3_0;
extern NSString * const GOSVersion_3_1;
extern NSString * const GOSVersion_3_2;
extern NSString * const GOSVersion_4_0;
extern NSString * const GOSVersion_4_1;
extern NSString * const GOSVersion_4_2;
extern NSString * const GOSVersion_4_3;
extern NSString * const GOSVersion_5_0;
extern NSString * const GOSVersion_5_1;
extern NSString * const GOSVersion_6_0;
extern NSString * const GOSVersion_6_1;
extern NSString * const GOSVersion_7_0;

@interface UIDevice (GKit)

/**
 * Check if the device is running on ipad or not
 * @return YES if device is ipad
 */
+ (BOOL) isPad;
+ (BOOL) isPhone;
+ (BOOL) isPhone5;

/**
 */
+ (BOOL) isRetinaDisplay;

/**
 * Check if the iOS version higher than a given version
 */
+ (BOOL) isOSVersionHigherThan:(NSString *)minVersion;
+ (BOOL) isOSVersionHigherThanOrEqualTo:(NSString *)minVersion;

/**
 * Check if the iOS version lower than a given version
 */
+ (BOOL) isOSVersionLowerThan:(NSString *)maxVersion;
+ (BOOL) isOSVersionLowerThanOrEqualTo:(NSString *)maxVersion;

@end

#pragma mark - 
//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

@interface UIDevice (IdentifierAddition)

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

@end
