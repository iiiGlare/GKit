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

#import "UIDevice+GKit.h"

@implementation UIDevice (GKit)

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isRetinaDisplay{
    return ([UIScreen instancesRespondToSelector:@selector(scale)] &&
            [[UIScreen mainScreen] scale] == 2.0);
}

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isOSVersionHigherThanVersion:(NSString *)minVersion includeEqual:(BOOL)isInclude
{
	NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
	NSComparisonResult comparisonResult = [sysVersion compare:minVersion];
	if (comparisonResult==NSOrderedDescending||(isInclude && comparisonResult==NSOrderedSame)) {
		return YES;
	}else{
		return NO;
	}
}

//////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isOSVersionLowerThanVersion:(NSString *)maxVersion includeEqual:(BOOL)isInclude
{
	NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
	NSComparisonResult comparisonResult = [sysVersion compare:maxVersion];
	if (comparisonResult==NSOrderedAscending||(isInclude && comparisonResult==NSOrderedSame)) {
		return YES;
	}else{
		return NO;
	}
}

@end
