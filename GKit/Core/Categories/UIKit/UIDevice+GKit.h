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

@interface UIDevice (GKit)

/**
 * Check if the device is running on ipad or not
 * @return YES if device is ipad
 */
+ (BOOL)isPad;

/**
 */
+ (BOOL)isRetinaDisplay;

/**
 * Check if the iOS version higher than a given version
 */
+ (BOOL)isOSVersionHigherThanVersion:(NSString *)minVersion includeEqual:(BOOL)isInclude;

/**
 * Check if the iOS version lower than a given version
 */
+ (BOOL)isOSVersionLowerThanVersion:(NSString *)maxVersion includeEqual:(BOOL)isInclude;

@end
