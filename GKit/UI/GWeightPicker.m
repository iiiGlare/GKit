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

#import "GWeightPicker.h"
#import "GCore.h"

#define GWeightPickerRepeatNumber 5000

@interface GWeightPicker ()
@property (nonatomic, assign) NSInteger numberOfIntegers;
@end

@implementation GWeightPicker

#pragma mark - Init & Memory Management
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
    _selectedWeight = 50.0f;
    _minimumWeight = 0.0f;
    _maximumWeight = 100.0f;

    // picker
    GPicker * gPicker = [[GPicker alloc] initWithFrame:self.bounds];
    gPicker.dataSource = self;
    gPicker.delegate = self;
    [self addSubviewToFill:gPicker];
    _picker = gPicker;
}

#pragma mark - Layout
- (void)didMoveToSuperview {
	_numberOfIntegers = (NSInteger)_maximumWeight - (NSInteger)_minimumWeight + 1;
	
    [_picker reloadAllComponents];
    [self setSelectedWeight:_selectedWeight animated:NO];
}

#pragma mark - Weight
- (void)setSelectedWeight:(CGFloat)selectedWeight animated:(BOOL)animated {
    // set selectedWeight
    _selectedWeight = selectedWeight;
    
    // scroll picker to selectedWeight
    NSInteger integer = _selectedWeight;
    NSInteger decimal = (_selectedWeight - integer) * 10;
    
    // integer 
    [_picker scrollComponent: [self componentForType:GWeightPickerComponentTypeInteger]
                       toRow: (integer-(NSInteger)_minimumWeight) + _numberOfIntegers*GWeightPickerRepeatNumber/2
          considerSelectable: NO
                    animated: animated];
    // point
    [_picker scrollComponent: [self componentForType:GWeightPickerComponentTypePoint]
                       toRow: 0
          considerSelectable: NO
                    animated: animated];
    // decimal
    [_picker scrollComponent: [self componentForType:GWeightPickerComponentTypeDecimal]
                       toRow: decimal + 10*GWeightPickerRepeatNumber/2
          considerSelectable: NO
                    animated: animated];
}

- (CGFloat)selectedWeight {
    // selected weight
    NSInteger integer = [_picker selectedRowInComponent:[self componentForType:GWeightPickerComponentTypeInteger]]%_numberOfIntegers + (NSInteger)_minimumWeight;
    NSInteger decimal = [_picker selectedRowInComponent:[self componentForType:GWeightPickerComponentTypeDecimal]]%10;
    return integer + decimal/10.0f;
}

#pragma mark - Reload
- (void)reloadComponentForType:(NSNumber *)componentType {
    [_picker reloadComponent:[self componentForType:componentType.integerValue]];
}


#pragma mark - GPicker

- (GWeightPickerComponentType)componentTypeForComponent:(NSInteger)component {
    switch (component) {
            // integer
        case 0:
            return GWeightPickerComponentTypeInteger;
            // point
        case 1:
            return GWeightPickerComponentTypePoint;
            // decimal
        case 2:
            return GWeightPickerComponentTypeDecimal;
            // none
        default:
            return GWeightPickerComponentTypeNone;
    }
}

- (NSUInteger)componentForType:(GWeightPickerComponentType)type {
    switch (type) {
            // integer
        case GWeightPickerComponentTypeInteger:
            return 0;
            // point
        case GWeightPickerComponentTypePoint:
            return 1;
            // decimal
        case GWeightPickerComponentTypeDecimal:
            return 2;
            // none
        default:
            return NSNotFound;
    }
}

// cell
- (NSInteger)numberOfComponentsInPicker:(GPicker *)picker {
    return 3;
}

- (NSInteger)picker:(GPicker *)picker numberOfRowsInComponent:(NSInteger)component {
    GWeightPickerComponentType componentType = [self componentTypeForComponent:component];
    switch (componentType) {
            // integer
        case GWeightPickerComponentTypeInteger:
		{
			if (_numberOfIntegers<3) {
				return _numberOfIntegers;
			} else {
				return _numberOfIntegers * GWeightPickerRepeatNumber;
			}
		}
            // point
        case GWeightPickerComponentTypePoint:
            return 1;
            // decimal
        case GWeightPickerComponentTypeDecimal:
            return 10 * GWeightPickerRepeatNumber;
            // none
        default:
            return 0;
    }
}

- (CGFloat)picker:(GPicker *)picker widthForComponent:(NSInteger)component {
    return picker.width / MAX(1, [self numberOfComponentsInPicker:picker]);
}

- (NSString *)picker:(GPicker *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    GWeightPickerComponentType componentType = [self componentTypeForComponent:component];
    switch (componentType) {
            // integer
        case GWeightPickerComponentTypeInteger:
            return [NSString stringWithFormat:@"%d", (NSInteger)_minimumWeight + row%_numberOfIntegers];
            // point
        case GWeightPickerComponentTypePoint:
            return @".";
            // decimal
        case GWeightPickerComponentTypeDecimal:
            return [NSString stringWithFormat:@"%d",row%10];
            // none
        default:
            return nil;
    }
}

- (void)picker:(GPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger integer, decimal;
    NSInteger integerComponent = [self componentForType:GWeightPickerComponentTypeInteger];
    NSInteger decimalComponent = [self componentForType:GWeightPickerComponentTypeDecimal];
    
    integer = [_picker selectedRowInComponent:integerComponent]%_numberOfIntegers + (NSInteger)_minimumWeight;
    decimal = [_picker selectedRowInComponent:decimalComponent]%10;
    CGFloat weight = integer + decimal * 0.1f;
    
    if (weight > _maximumWeight) {
        // max
        [self setSelectedWeight:_maximumWeight animated:YES];
    } else if (weight < _minimumWeight) {
        // min
        [self setSelectedWeight:_minimumWeight animated:YES];
    }
    
    // reload components
    GWeightPickerComponentType componentType = [self componentTypeForComponent:component];
    if ((GWeightPickerComponentTypeInteger == componentType)) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadComponentForType:) object:GNumberWithInteger(GWeightPickerComponentTypeDecimal)];
        [self performSelector:@selector(reloadComponentForType:) withObject:GNumberWithInteger(GWeightPickerComponentTypeDecimal) afterDelay:0.3];
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
