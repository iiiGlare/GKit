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

#import "NSUserDefaults+GKit.h"

@implementation NSUserDefaults (GKit)
//BOOL
+ (BOOL)boolForKey:(NSString *)key withDefault:(BOOL)defaultValue
{
    NSNumber *value = [NSUserDefaults objectForKey:key
                                       withDefault:[NSNumber numberWithBool:defaultValue]];
    return [value boolValue];
}
+ (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [NSUserDefaults setObject:[NSNumber numberWithBool:value]
                       forKey:key];
}

//Integer
+ (NSInteger)integerForKey:(NSString *)key withDefault:(NSInteger)defaultValue
{
    NSNumber *value = [NSUserDefaults objectForKey:key
                                       withDefault:[NSNumber numberWithInteger:defaultValue]];
    return [value integerValue];
}
+ (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [NSUserDefaults setObject:[NSNumber numberWithInteger:value]
                       forKey:key];
}

//float
+ (float)floatForKey:(NSString *)key withDefault:(float)defaultValue
{
    NSNumber *value = [NSUserDefaults objectForKey:key
                                       withDefault:[NSNumber numberWithFloat:defaultValue]];
    return [value floatValue];
}
+ (void)setFloat:(float)value forKey:(NSString *)key
{
    [NSUserDefaults setObject:[NSNumber numberWithFloat:value]
                       forKey:key];
}

//double
+ (double)doubleForKey:(NSString *)key withDefault:(double)defaultValue
{
    NSNumber *value = [NSUserDefaults objectForKey:key
                                       withDefault:[NSNumber numberWithDouble:defaultValue]];
    return [value doubleValue];
    
}
+ (void)setDouble:(double)value forKey:(NSString *)key
{
    [NSUserDefaults setObject:[NSNumber numberWithDouble:value]
                       forKey:key];
}

//Object
+ (id)objectForKey:(NSString *)key withDefault:(id)defaultValue
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (value==nil) {
        return defaultValue;
    }
    return value;
}
+ (void)setObject:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

@end
