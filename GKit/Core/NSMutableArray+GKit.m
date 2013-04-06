//
//  NSMutableArray+GKit.m
//  GKitDemo
//
//  Created by Glare on 13-4-3.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "NSMutableArray+GKit.h"

@implementation NSMutableArray (GKit)

- (void)insertObjectAtCenter:(id)anObject
{
    [self insertObject:anObject atIndex:self.count/2];
}

@end
