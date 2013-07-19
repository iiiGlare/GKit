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
#import "GPicker.h"

enum {
    GDatePickerStyleDate,
    GDatePickerStyleTime,
    GDatePickerStyleDateTime
};
typedef NSInteger GDatePickerStyle;

enum  {
    GDatePickerComponentTypeNone,
    GDatePickerComponentTypeYear,
    GDatePickerComponentTypeMonth,
    GDatePickerComponentTypeDay,
    GDatePickerComponentTypeHour,
    GDatePickerComponentTypeMinute,
    GDatePickerComponentTypeColon
};
typedef NSInteger GDatePickerComponentType;

@interface GDatePicker : UIControl <
    GPickerDataSource, GPickerDelegate
>

// picker
@property (nonatomic, weak, readonly) GPicker * picker;
@property (nonatomic, assign) GDatePickerStyle datePickerStyle; // default is GDatePickerStyleDate

// date
@property (nonatomic, strong) NSDate * selectedDate;
@property (nonatomic, strong) NSDate * minimumDate;
@property (nonatomic, strong) NSDate * maximumDate;

// year
@property (nonatomic, assign) NSInteger beginYear;              // default is 1970
@property (nonatomic, assign) NSInteger numberOfYears;           // default is 100

// method
- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated;

// init & memory management
- (void)customInitialize;
- (void)prepareToRemove;

@end
