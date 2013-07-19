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

enum  {
    GWeightPickerComponentTypeNone,
    GWeightPickerComponentTypeInteger,
    GWeightPickerComponentTypeDecimal,
    GWeightPickerComponentTypePoint
};
typedef NSInteger GWeightPickerComponentType;


@interface GWeightPicker : UIControl
<
    GPickerDataSource, GPickerDelegate
>

// picker
@property (nonatomic, weak, readonly) GPicker * picker;

// weight
@property (nonatomic, assign) CGFloat selectedWeight;   // default 50.0 kg
@property (nonatomic, assign) CGFloat minimumWeight;    // default 0.0 kg
@property (nonatomic, assign) CGFloat maximumWeight;    // default 100.0 kg

// method
- (void)setSelectedWeight:(CGFloat)selectedWeight animated:(BOOL)animated;

@end
