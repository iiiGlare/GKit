//
//  GCommonMetrics.m
//  GKitDemo
//
//  Created by Hua Cao on 13-3-17.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GCommonMetrics.h"

////////////////////////////////////////////////////////////
CGRect GScreenBounds(void)
{
	return [[UIScreen mainScreen] bounds];
}
CGRect GApplicationFrame(void)
{
	return [[UIScreen mainScreen] applicationFrame];
}
////////////////////////////////////////////////////////////
CGFloat GStatusBarHeight(void)
{
	CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
	return CGRectGetHeight(frame);
}
////////////////////////////////////////////////////////////
CGFloat GPickerHeight(void)
{
	return 216.0f;
}



@implementation GCommonMetrics

@end
