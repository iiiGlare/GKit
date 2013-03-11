//
//  NSObject+GKit.m
//  YouHuo
//
//  Created by Glare on 13-3-2.
//
//

#import "NSObject+GKit.h"

BOOL GObjectIsNil(NSObject *object)
{
	if (object==nil || [object isEqual:[NSNull null]]) {
		return YES;
	}else {
		return NO;
	}
}

@implementation NSObject (GKit)

@end
