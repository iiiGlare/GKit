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

#import "GTabBarController.h"
#import "GDebuggingTools.h"

@implementation GTabBarController

+ (id)newWithControllerNames:(NSArray *)names
{
	if ([names count]==0) {
		return nil;
	}
	NSMutableArray *controllers = [[NSMutableArray alloc] initWithCapacity:[names count]];
	for (NSInteger i=0; i<[names count]; i++) {
		Class ViewController = NSClassFromString([NSString stringWithFormat:@"%@ViewController",[names objectAtIndex:i]]);
		GASSERT(ViewController!=NULL);
		[controllers addObject:[[UINavigationController alloc] initWithRootViewController:[ViewController new]]];
	}
	
	GTabBarController *tabBarController = [[GTabBarController alloc] init];
	[tabBarController setViewControllers:controllers animated:NO];
	return tabBarController;
}

@end
