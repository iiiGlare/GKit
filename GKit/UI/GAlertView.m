//
//  GAlertView.m
//  GKitDemo
//
//  Created by Hua Cao on 13-3-28.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "GAlertView.h"

@implementation GAlertView

+ (void)showMessage:(NSString *)message
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

@end
