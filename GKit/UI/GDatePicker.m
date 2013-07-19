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

#import "GDatePicker.h"

#import "GCore.h"

#define GDatePickerRepeatNumber 5000

@interface GDatePicker ()
{
	BOOL _isYearCycled;
}
@end

@implementation GDatePicker

#pragma mark - Init & Memory Management
- (void)prepareToRemove {
	NSMutableArray * tableViews = [_picker performSelector:@selector(componentTableViews)];
	for (UITableView * tableView in tableViews) {
		tableView.delegate = nil;
		tableView.dataSource = nil;
	}
	[NSObject cancelPreviousPerformRequestsWithTarget:_picker];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInitialize];
    }
    return self;
}

- (void)customInitialize {
    // init
    _datePickerStyle = GDatePickerStyleDate;
    
    _selectedDate = [NSDate date];
    _minimumDate = nil;
    _maximumDate = nil;
    
    _beginYear = 1970;
    _numberOfYears = 100;
    
    
    // picker
    GPicker * gPicker = [[GPicker alloc] initWithFrame:self.bounds];
    gPicker.dataSource = self;
    gPicker.delegate = self;
    [self addSubviewToFill:gPicker];
    _picker = gPicker;
}

#pragma mark - Layout
- (void)didMoveToSuperview {
    [_picker reloadAllComponents];
    [self setSelectedDate:_selectedDate animated:NO];
}
#pragma mark - Date
- (void)setSelectedDate:(NSDate *)selectedDate animated:(BOOL)animated {
    // set selectedDate
    _selectedDate = selectedDate;
    
    // scroll picker to selectedDate
    if (GDatePickerStyleDate == _datePickerStyle) {
        // selected date
        NSInteger year = [[selectedDate dateStringWithFormat:@"yyyy"] integerValue];
        NSInteger month = [[selectedDate dateStringWithFormat:@"MM"] integerValue];
        NSInteger day = [[selectedDate dateStringWithFormat:@"dd"] integerValue];
        
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeYear]
						   toRow: year - _beginYear + (_isYearCycled?_numberOfYears*GDatePickerRepeatNumber/2:0)
			  considerSelectable: NO
						animated: animated];
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeMonth]
						   toRow: month - 1 + 12*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeDay]
						   toRow: day - 1 + 31*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
    } else if (GDatePickerStyleTime == _datePickerStyle) {
        // seleted time
        NSInteger hour = [[selectedDate dateStringWithFormat:@"HH"] integerValue];
        NSInteger minute = [[selectedDate dateStringWithFormat:@"mm"] integerValue];
        
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeHour]
						   toRow: hour + 24*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeColon]
						   toRow: 0
			  considerSelectable: NO
						animated: animated];
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeMinute]
						   toRow: minute + 60*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
    } else if (GDatePickerStyleDateTime == _datePickerStyle) {
        // selected date
        NSInteger month = [[selectedDate dateStringWithFormat:@"MM"] integerValue];
        NSInteger day = [[selectedDate dateStringWithFormat:@"dd"] integerValue];
        NSInteger hour = [[selectedDate dateStringWithFormat:@"HH"] integerValue];
        NSInteger minute = [[selectedDate dateStringWithFormat:@"mm"] integerValue];
        
        // month
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeMonth]
						   toRow: month - 1 + 12*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
        // day
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeDay]
						   toRow: day - 1 + 31*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
        // hour
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeHour]
						   toRow: hour + 24*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
        // colon
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeColon]
						   toRow: 0
			  considerSelectable: NO
						animated: animated];
        // minute
        [_picker scrollComponent: [self componentForType:GDatePickerComponentTypeMinute]
						   toRow: minute + 60*GDatePickerRepeatNumber/2
			  considerSelectable: NO
						animated: animated];
    }
}

//- (NSDate *)selectedDate {
//    
//    if (GDatePickerStyleDate == _datePickerStyle) {
//        // selected date
//		return _selectedDate;
//    } else if (GDatePickerStyleTime == _datePickerStyle) {
//        // seleted time
//        NSInteger hour = [_picker selectedRowInComponent:[self componentForType:GDatePickerComponentTypeHour]]%24;
//        NSInteger minute = [_picker selectedRowInComponent:[self componentForType:GDatePickerComponentTypeMinute]]%60;
//        return [[_selectedDate beginningOfDay] dateByAddingTimeInterval:GTimeIntervalFromMinitues(hour*60+minute)];
//    }
//    return _selectedDate;
//}

#pragma mark - Reload
- (void)reloadComponentForType:(NSNumber *)componentType {
    [_picker reloadComponent:[self componentForType:componentType.integerValue]];
}


#pragma mark - GPicker

// cell
- (GDatePickerComponentType)componentTypeForComponent:(NSInteger)component {
    if (GDatePickerStyleDate == _datePickerStyle) {
        // date
        switch (component) {
                // year
            case 0:
                return GDatePickerComponentTypeYear;
                // month
            case 1:
                return GDatePickerComponentTypeMonth;
                // day
            case 2:
                return GDatePickerComponentTypeDay;
                // none
            default:
                return GDatePickerComponentTypeNone;
        }
    }
    else if (GDatePickerStyleTime == _datePickerStyle) {
        // time
        switch (component) {
                // hour
            case 0:
                return GDatePickerComponentTypeHour;
                // colon
            case 1:
                return GDatePickerComponentTypeColon;
                // minute
            case 2:
                return GDatePickerComponentTypeMinute;
                // none
            default:
                return GDatePickerComponentTypeNone;
        }
    }
    else if (GDatePickerStyleDateTime == _datePickerStyle) {
        // date time
        switch (component) {
                // month
            case 0:
                return GDatePickerComponentTypeMonth;
                // day
            case 1:
                return GDatePickerComponentTypeDay;
                // hour
            case 2:
                return GDatePickerComponentTypeHour;
                // colon
            case 3:
                return GDatePickerComponentTypeColon;
                // minute
            case 4:
                return GDatePickerComponentTypeMinute;
                // none
            default:
                return GDatePickerComponentTypeNone;
        }
    }
    return GDatePickerComponentTypeNone;
}

- (NSUInteger)componentForType:(GDatePickerComponentType)type {
    if (GDatePickerStyleDate == _datePickerStyle) {
        // date
        switch (type) {
                // year
            case GDatePickerComponentTypeYear:
                return 0;
                // month
            case GDatePickerComponentTypeMonth:
                return 1;
                // day
            case GDatePickerComponentTypeDay:
                return 2;
                // none
            default:
                return NSNotFound;
        }
    }
    else if (GDatePickerStyleTime == _datePickerStyle) {
        // time
        switch (type) {
                // hour
            case GDatePickerComponentTypeHour:
                return 0;
                // colon
            case GDatePickerComponentTypeColon:
                return 1;
                // minute
            case GDatePickerComponentTypeMinute:
                return 2;
                // none
            default:
                return NSNotFound;
        }
    }
    else if (GDatePickerStyleDateTime == _datePickerStyle) {
        // date time
        switch (type) {
                // month
            case GDatePickerComponentTypeMonth:
                return 0;
                // day
            case GDatePickerComponentTypeDay:
                return 1;
                // hour
            case GDatePickerComponentTypeHour:
                return 2;
                // colon
            case GDatePickerComponentTypeColon:
                return 3;
                // minute
            case GDatePickerComponentTypeMinute:
                return 4;
                // none
            default:
                return NSNotFound;
        }
    }
    return NSNotFound;
}

- (NSInteger)numberOfComponentsInPicker:(GPicker *)picker {
    if (GDatePickerStyleDate == _datePickerStyle) {
        // date
        return 3;
    }
    else if (GDatePickerStyleTime == _datePickerStyle) {
        // time
        return 3;
    }
    else if (GDatePickerStyleDateTime == _datePickerStyle) {
        // date time
        return 5;
    }
    return 0;
}

- (NSInteger)picker:(GPicker *)picker numberOfRowsInComponent:(NSInteger)component {
    GDatePickerComponentType componentType = [self componentTypeForComponent:component];
    switch (componentType) {
            // year
        case GDatePickerComponentTypeYear:
			if (_numberOfYears<3) {
				_isYearCycled = NO;
				return _numberOfYears;
			} else {
				_isYearCycled = YES;
				return _numberOfYears * GDatePickerRepeatNumber;
			}
            // month
        case GDatePickerComponentTypeMonth:
            return 12 * GDatePickerRepeatNumber;
            // day
        case GDatePickerComponentTypeDay:
            return 31 * GDatePickerRepeatNumber;
            // hour
        case GDatePickerComponentTypeHour:
            return 24 * GDatePickerRepeatNumber;
            // minute
        case GDatePickerComponentTypeMinute:
            return 60 * GDatePickerRepeatNumber;
            // colon
        case GDatePickerComponentTypeColon:
            return 1;
            // none
        default:
            return 0;
    }
}

- (CGFloat)picker:(GPicker *)picker widthForComponent:(NSInteger)component {
    return picker.width / MAX(1, [self numberOfComponentsInPicker:picker]);
}

- (NSString *)picker:(GPicker *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    GDatePickerComponentType componentType = [self componentTypeForComponent:component];
    switch (componentType) {
            // year
        case GDatePickerComponentTypeYear:
            return [NSString stringWithFormat:@"%d",row%_numberOfYears+_beginYear];
            // month
        case GDatePickerComponentTypeMonth:
            return [NSString stringWithFormat:@"%d月",row%12+1];
            // day
        case GDatePickerComponentTypeDay:
            return [NSString stringWithFormat:@"%d",row%31+1];
            // hour
        case GDatePickerComponentTypeHour:
            return GTimerElementStringFormElement(row%24);
            // minute
        case GDatePickerComponentTypeMinute:
            return GTimerElementStringFormElement(row%60);
            // colon
        case GDatePickerComponentTypeColon:
            return @":";
            // none
        default:
            return nil;
    }
}

- (BOOL)picker:(GPicker *)picker selectableForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (GDatePickerStyleDate == _datePickerStyle) {
        // date
        
        NSInteger year, month ,day;
        NSInteger yearComponent = [self componentForType:GDatePickerComponentTypeYear];
        NSInteger monthComponent = [self componentForType:GDatePickerComponentTypeMonth];
        NSInteger dayComponent = [self componentForType:GDatePickerComponentTypeDay];
        
        GDatePickerComponentType componentType = [self componentTypeForComponent:component];
        if (GDatePickerComponentTypeYear == componentType) {
            // for year
            year = row%_numberOfYears + _beginYear;
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
        } else if (GDatePickerComponentTypeMonth == componentType) {
            // for month
            year = [picker selectedRowInComponent:yearComponent]%_numberOfYears + _beginYear;
            month = row%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
        } else {
            // for day
            year = [picker selectedRowInComponent:yearComponent]%_numberOfYears + _beginYear;
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = row%31 + 1;
        }
        
        // check day
        if (day > [NSDate numberOfDaysForMonth:month inYear:year]) {
            return NO;
        }

        // minimum 、maximum control
        if (_minimumDate || _maximumDate) {
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate * date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",year,month,day]];
            if ((_minimumDate && [date compare:_minimumDate]==NSOrderedAscending) ||
                (_maximumDate && [date compare:_maximumDate]==NSOrderedDescending)) {
                return NO;
            }
        }
    }
    else if (GDatePickerStyleDateTime == _datePickerStyle) {
        // date time
        
        NSInteger year, month, day, hour, minute;
        NSInteger monthComponent = [self componentForType:GDatePickerComponentTypeMonth];
        NSInteger dayComponent = [self componentForType:GDatePickerComponentTypeDay];
        NSInteger hourComponent = [self componentForType:GDatePickerComponentTypeHour];
        NSInteger minuteComponent = [self componentForType:GDatePickerComponentTypeMinute];
        
        GDatePickerComponentType componentType = [self componentTypeForComponent:component];
        
        year = [[_selectedDate dateStringWithFormat:@"yyyy"] integerValue];
        if (GDatePickerComponentTypeMonth == componentType) {
            // for month
            month = row%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
            hour = [picker selectedRowInComponent:hourComponent]%24;
            minute = [picker selectedRowInComponent:minuteComponent]%60;
        }
        else if (GDatePickerComponentTypeDay == componentType) {
            // for day
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = row%31 + 1;
            hour = [picker selectedRowInComponent:hourComponent]%24;
            minute = [picker selectedRowInComponent:minuteComponent]%60;
        }
        else if (GDatePickerComponentTypeHour == componentType){
            // for hour
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
            hour = row%24;
            minute = [picker selectedRowInComponent:minuteComponent]%60;            
        }
        else {
            // for minute
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
            hour = [picker selectedRowInComponent:hourComponent]%24;
            minute = row%60;
        }
        
        // check day
        if (day > [NSDate numberOfDaysForMonth:month inYear:year]) {
            return NO;
        }
        
        // minimum 、maximum control
        if (_minimumDate || _maximumDate) {
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate * date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d %d:%d",year,month,day, hour, minute]];
            if ((_minimumDate && [date compare:_minimumDate]==NSOrderedAscending) ||
                (_maximumDate && [date compare:_maximumDate]==NSOrderedDescending)) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)picker:(GPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // style date
    if (GDatePickerStyleDate == _datePickerStyle) {
        
        NSInteger year, month ,day;
        NSInteger yearComponent = [self componentForType:GDatePickerComponentTypeYear];
        NSInteger monthComponent = [self componentForType:GDatePickerComponentTypeMonth];
        NSInteger dayComponent = [self componentForType:GDatePickerComponentTypeDay];
        
        GDatePickerComponentType componentType = [self componentTypeForComponent:component];
        if (GDatePickerComponentTypeYear == componentType) {
            // for year
            year = row%_numberOfYears + _beginYear;
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
        } else if (GDatePickerComponentTypeMonth == componentType) {
            // for month
            year = [picker selectedRowInComponent:yearComponent]%_numberOfYears + _beginYear;
            month = row%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
        } else {
            // for day
            year = [picker selectedRowInComponent:yearComponent]%_numberOfYears + _beginYear;
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = row%31 + 1;
        }

		NSInteger numberOfDays = [NSDate numberOfDaysForMonth:month inYear:year];
		if (day > numberOfDays) {
			day = numberOfDays;
		}
		
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * selectedDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d",year,month,day]];

        if (_maximumDate && ([selectedDate compare:_maximumDate]==NSOrderedDescending)) {
            // max
            [self setSelectedDate:_maximumDate animated:NO];
        } else if (_minimumDate && [selectedDate compare:_minimumDate]==NSOrderedAscending) {
            // min
            [self setSelectedDate:_minimumDate animated:NO];
        } else {
            // normal
			[self setSelectedDate:selectedDate animated:NO];
        }
        
		
        // reload components
        // reload month
        if ((GDatePickerComponentTypeYear == componentType)) {
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadComponentForType:) object:GNumberWithInteger(GDatePickerComponentTypeMonth)];
            [self performSelector:@selector(reloadComponentForType:) withObject:GNumberWithInteger(GDatePickerComponentTypeMonth) afterDelay:0.3];
        }
        
        // reload day
        if ((GDatePickerComponentTypeMonth == componentType) ||
            (GDatePickerComponentTypeYear == componentType)) {
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadComponentForType:) object:GNumberWithInteger(GDatePickerComponentTypeDay)];
            [self performSelector:@selector(reloadComponentForType:) withObject:GNumberWithInteger(GDatePickerComponentTypeDay) afterDelay:0.3];
        }        
    }
    else if (GDatePickerStyleTime == _datePickerStyle) {
        NSInteger hour = [_picker selectedRowInComponent:[self componentForType:GDatePickerComponentTypeHour]]%24;
        NSInteger minute = [_picker selectedRowInComponent:[self componentForType:GDatePickerComponentTypeMinute]]%60;
        NSDate * selectedDate  = [[_selectedDate beginningOfDay] dateByAddingTimeInterval:GTimeIntervalFromMinitues(hour*60+minute)];
        
        [self setSelectedDate:selectedDate animated:NO];
    }
    else if (GDatePickerStyleDateTime == _datePickerStyle) {
        // date time
        
        NSInteger year, month, day, hour, minute;
        NSInteger monthComponent = [self componentForType:GDatePickerComponentTypeMonth];
        NSInteger dayComponent = [self componentForType:GDatePickerComponentTypeDay];
        NSInteger hourComponent = [self componentForType:GDatePickerComponentTypeHour];
        NSInteger minuteComponent = [self componentForType:GDatePickerComponentTypeMinute];
        
        GDatePickerComponentType componentType = [self componentTypeForComponent:component];
        
        year = [[_selectedDate dateStringWithFormat:@"yyyy"] integerValue];
        if (GDatePickerComponentTypeMonth == componentType) {
            // for month
            month = row%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
            hour = [picker selectedRowInComponent:hourComponent]%24;
            minute = [picker selectedRowInComponent:minuteComponent]%60;
        }
        else if (GDatePickerComponentTypeDay == componentType) {
            // for day
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = row%31 + 1;
            hour = [picker selectedRowInComponent:hourComponent]%24;
            minute = [picker selectedRowInComponent:minuteComponent]%60;
        }
        else if (GDatePickerComponentTypeHour == componentType){
            // for hour
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
            hour = row%24;
            minute = [picker selectedRowInComponent:minuteComponent]%60;
        }
        else {
            // for minute
            month = [picker selectedRowInComponent:monthComponent]%12 + 1;
            day = [picker selectedRowInComponent:dayComponent]%31 + 1;
            hour = [picker selectedRowInComponent:hourComponent]%24;
            minute = row%60;
        }

        //
		NSInteger numberOfDays = [NSDate numberOfDaysForMonth:month inYear:year];
		if (day > numberOfDays) {
			day = numberOfDays;
		}
		
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate * selectedDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d %d:%d",year,month,day, hour, minute]];
        
        if (_maximumDate && ([selectedDate compare:_maximumDate]==NSOrderedDescending)) {
            // max
            [self setSelectedDate:_maximumDate animated:NO];
        } else if (_minimumDate && [selectedDate compare:_minimumDate]==NSOrderedAscending) {
            // min
            [self setSelectedDate:_minimumDate animated:NO];
        } else {
            // normal
			[self setSelectedDate:selectedDate animated:NO];
        }
        
		
        // reload components
        // reload day
        if ((GDatePickerComponentTypeMonth == componentType)) {
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadComponentForType:) object:GNumberWithInteger(GDatePickerComponentTypeDay)];
            [self performSelector:@selector(reloadComponentForType:) withObject:GNumberWithInteger(GDatePickerComponentTypeDay) afterDelay:0.3];
        }
    }
    
    // send actions
    [self performSelector:@selector(sendActionsForValueChangedEventsAfterDelay) withObject:nil afterDelay:0.3];
}

- (void)sendActionsForValueChangedEventsAfterDelay {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (void)picker:(GPicker *)picker didScrollCell:(UIView *)cell inComponent:(NSInteger)component atOffset:(CGFloat)offset {
    CGFloat scale = 1.0 - MIN(1.0, ABS(offset))*0.2;
    cell.transform = CGAffineTransformMakeScale(scale, scale);
}

@end
