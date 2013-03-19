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
#import <UIKit/UIKit.h>

/**
 * UIView Autoresizing Mask
 */
#define GViewAutoresizingNone UIViewAutoresizingNone
#define GViewAutoresizingFlexibleMargins UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin
#define GViewAutoresizingFlexibleSize UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
#define GViewAutoresizingFlexibleAll GViewAutoresizingFlexibleMargins|GViewAutoresizingFlexibleSize

/**
 * UIView Layout
 */

//Screen
CGRect GScreenBounds(void);
CGRect GApplicationFrame(void);

//Status Bar
CGFloat GStatusBarHeight(void);

//Picker
CGFloat GPickerHeight(void);



@interface GCommonMetrics : NSObject

@end
