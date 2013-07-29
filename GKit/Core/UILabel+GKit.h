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

typedef NS_ENUM(NSInteger, GTextAlignment){
    GTextAlignmentLeft      = 0,
    GTextAlignmentCenter    = 1,
    GTextAlignmentRight     = 2,
    GTextAlignmentJustified = 3,
    GTextAlignmentNatural   = 4,
};

typedef NS_ENUM(NSInteger, GLineBreakMode) {		/* What to do with long lines */
    GLineBreakByWordWrapping = 0,     	/* Wrap at word boundaries, default */
    GLineBreakByCharWrapping,		/* Wrap at character boundaries */
    GLineBreakByClipping,		/* Simply clip */
    GLineBreakByTruncatingHead,	/* Truncate at head of line: "...wxyz" */
    GLineBreakByTruncatingTail,	/* Truncate at tail of line: "abcd..." */
    GLineBreakByTruncatingMiddle	/* Truncate middle of line:  "ab...yz" */
};

//typedef enum {
//    UILineBreakModeWordWrap = 0,
//    UILineBreakModeCharacterWrap,
//    UILineBreakModeClip,
//    UILineBreakModeHeadTruncation,
//    UILineBreakModeTailTruncation,
//    UILineBreakModeMiddleTruncation,
//} UILineBreakMode;

@interface UILabel (GKit)

@property (nonatomic, assign) GTextAlignment textAlignmentG;
@property (nonatomic, assign) GLineBreakMode lineBreakModeG;

@end
