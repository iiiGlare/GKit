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


@interface NSArray (GKit)
/**
 Convinient method to check if the array is empty or not.
 */
@property (nonatomic, readonly) BOOL isEmpty;

/**
 Return the first object or nil if array is empty.
 */
- (id)firstObject;

/**
 Replace objectAtIndex
 
 目的1：可以使用负数，来访问数组末尾的元素，例如：-1表示最后一个，-2表示倒数第二个
 目的2：进行位置合法性检查，避免崩溃

 */
- (id)objectAtPosition:(NSInteger)position;
/**
 循环访问数组内容
 */
- (id)objectAtCirclePosition:(NSInteger)position;

@end
