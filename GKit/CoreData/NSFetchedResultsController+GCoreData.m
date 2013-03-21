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

#import "NSFetchedResultsController+GCoreData.h"

@implementation NSFetchedResultsController (GCoreData)

- (BOOL)isIndexPathValid:(NSIndexPath *)indexPath
{
	//检查indexPath本身的合法性
	if (indexPath.section<0 || indexPath.row< 0) {
		return NO;
	}
	
	//检查indexPath是否在结果范围之内
	NSArray *sections = [self sections];
	if (indexPath.section >= [sections count]) {
		return NO;
	}else{
		id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:indexPath.section];
		NSInteger numberOfObjects = [sectionInfo numberOfObjects];
		if (indexPath.row >= numberOfObjects) {
			return NO;
		}else{
			return YES;
		}
	}
}

@end
