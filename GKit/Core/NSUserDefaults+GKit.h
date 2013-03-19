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

@interface NSUserDefaults (GKit)

/**
 * Return value for a key,
 * if the value object is nil, return the given default value
 */
+ (BOOL)boolForKey:(NSString *)key withDefault:(BOOL)defaultValue;
+ (void)setBool:(BOOL)value forKey:(NSString *)key;

+ (NSInteger)integerForKey:(NSString *)key withDefault:(NSInteger)defaultValue;
+ (void)setInteger:(NSInteger)value forKey:(NSString *)key;

+ (float)floatForKey:(NSString *)key withDefault:(float)defaultValue;
+ (void)setFloat:(float)value forKey:(NSString *)key;

+ (double)doubleForKey:(NSString *)key withDefault:(double)defaultValue;
+ (void)setDouble:(double)value forKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key withDefault:(id)defaultValue;
+ (void)setObject:(id)value forKey:(NSString *)key;

@end
