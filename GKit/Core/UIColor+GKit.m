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

//white
UIColor * GColorWithWhite(CGFloat white)
{
    return GColorWithWhiteAlpha(white, 1.0);
}

//white alpha
UIColor * GColorWithWhiteAlpha(CGFloat white, CGFloat alpha)
{
    return [UIColor colorWithWhite:(white)/255.0f alpha:(alpha)];
}

//r g b
UIColor * GColorWithRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return GColorWithRGBA(red, green, blue, 1.0);
}

//r g b alpha
UIColor * GColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:(red)/255.0f green:(green)/255.0f blue:(blue)/255.0f alpha:(alpha)];
}

//hex
UIColor * GColorWithHex(unsigned int hex)
{
	return GColorWithHexAlpha(hex, 1.0);
}

//hex alpha
UIColor * GColorWithHexAlpha(unsigned int hex, CGFloat alpha)
{
	return GColorWithRGBA((float)((hex & 0xFF0000) >> 16),
                          (float)((hex & 0xFF00) >> 8),
                          (float)((hex & 0xFF)),
                          alpha);
}

//random
UIColor * GRandomColor(void)
{
	return GRandomColorWithAlpha(1.0);
}

//random alpha
UIColor * GRandomColorWithAlpha(CGFloat alpha)
{
	return GColorWithRGBA(arc4random() % 255,
						  arc4random() % 255,
						  arc4random() % 255,
						  alpha);
}

@implementation UIColor (GKit)

@end
