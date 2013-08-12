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

/**
 * Create UIColor object 
 */
//white
UIColor * GColorWithWhite(CGFloat white);

//white alpha
UIColor * GColorWithWhiteAlpha(CGFloat white, CGFloat alpha);

//r g b
UIColor * GColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);

//r g b a
UIColor * GColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

//hex
UIColor * GColorWithHex(unsigned int hex);

//hex alpha
UIColor * GColorWithHexAlpha(unsigned int hex, CGFloat alpha);

//random
UIColor * GRandomColor(void);

//random alpha
UIColor * GRandomColorWithAlpha(CGFloat alpha);

//clear
UIColor * GClearColor(void);

@interface UIColor (GKit)

@end
