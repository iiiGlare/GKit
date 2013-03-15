//
//  NSNumber+GKit.m
//  GKitDemo
//
//  Created by Hua Cao on 13-3-15.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "NSNumber+GKit.h"

NSNumber * GNumberWithInt(int value)
{
	return [NSNumber numberWithInt:value];
}

NSNumber * GNumberWithInteger(NSInteger value)
{
	return [NSNumber numberWithInteger:value];
}

NSNumber * GNumberWithUnsignedInteger(NSUInteger value)
{
	return [NSNumber numberWithUnsignedInteger:value];
}

NSNumber * GNumberWithFloat(float value)
{
	return [NSNumber numberWithFloat:value];
}

NSNumber * GNumberWithDouble(double value)
{
	return [NSNumber numberWithDouble:value];
}

NSNumber * GNumberWithBOOL(BOOL value)
{
	return [NSNumber numberWithBool:value];
}

@implementation NSNumber (GKit)

@end
