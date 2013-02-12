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

#import "UIColor+GKit.h"

//////////////////////////////////////////////////////////////////////////////////
UIColor* GMakeWhiteColor(CGFloat white)
{
    return GMakeWhiteAlphaColor(white, 1.0);
}

UIColor* GMakeWhiteAlphaColor(CGFloat white, CGFloat alpha)
{
    return [UIColor colorWithWhite:(white)/255.0f alpha:(alpha)];
}

UIColor* GMakeRGBColor(CGFloat red, CGFloat green, CGFloat blue)
{
    return GMakeRGBAColor(red, green, blue, 1.0);
}

UIColor* GMakeRGBAColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:(red)/255.0f green:(green)/255.0f blue:(blue)/255.0f alpha:(alpha)];
}

@implementation UIColor (GKit)

//////////////////////////////////////////////////////////////////////////////////
+ (id) colorWithHex:(unsigned int)hex{
	return [UIColor colorWithHex:hex alpha:1];
}

//////////////////////////////////////////////////////////////////////////////////
+ (id) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha{
	
	return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
	
}

//////////////////////////////////////////////////////////////////////////////////
+ (UIColor*) randomColor{
	
	int r = arc4random() % 255;
	int g = arc4random() % 255;
	int b = arc4random() % 255;
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
	
}

@end
