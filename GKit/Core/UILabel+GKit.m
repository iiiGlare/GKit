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

#import "UILabel+GKit.h"
#import "UIDevice+GKit.h"

@implementation UILabel (GKit)
@dynamic textAlignmentG;
@dynamic lineBreakModeG;

#pragma mark - Getter/Setter

// textAlignmentG
- (GTextAlignment)textAlignmentG {
    return (NSInteger)[self textAlignment];
}

- (void)setTextAlignmentG:(GTextAlignment)textAlignment {
    if ([UIDevice isOSVersionHigherThanOrEqualTo:G_OS_6_0]) {
        [self setTextAlignment:(NSInteger)textAlignment];
    }
    else {
        if (textAlignment<=GTextAlignmentRight) {
            [self setTextAlignment:(NSInteger)textAlignment];
        }
    }
}

// lineBreakModeG
- (GLineBreakMode)lineBreakModeG {
    return (NSInteger)[self lineBreakMode];
}

- (void)setLineBreakModeG:(GLineBreakMode)lineBreakModeG {
    if ([UIDevice isOSVersionHigherThanOrEqualTo:G_OS_6_0]) {
        [self setLineBreakMode:(NSInteger)lineBreakModeG];
    }
    else {
        [self setLineBreakMode:(NSInteger)lineBreakModeG];
    }
}


@end
