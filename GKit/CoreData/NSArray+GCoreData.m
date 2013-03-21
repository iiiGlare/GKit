//
//  NSArray+GCoreData.m
//  GKitDemo
//
//  Created by Hua Cao on 13-3-21.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "NSArray+GCoreData.h"

#import "NSSet+GCoreData.h"
#import "NSManagedObject+GCoreData.h"


@implementation NSArray (GCoreData)

//
-(void)saveToStore
{
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
	{
		if ([obj respondsToSelector:@selector(saveToStore)]) {
			[obj saveToStore];
		}
	}];
}

//
- (void)deleteFromStore
{
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
	 {
		 if ([obj respondsToSelector:@selector(deleteFromStore)]) {
			 [obj deleteFromStore];
		 }
	 }];
}

@end
