//
//  GUIActionEventHandleResult.m
//  GKitDemo
//
//  Created by Hua Cao on 14-2-17.
//  Copyright (c) 2014年 Hoewo. All rights reserved.
//

#import "GUIActionEventHandleResult.h"

@interface GUIActionEventHandleResult ()

@property (nonatomic, assign) BOOL shouldContinueDispatch;

@end

@implementation GUIActionEventHandleResult

+ (instancetype) resultWithContinueDispatch:(BOOL)shouldContinueDispatch
{
    GUIActionEventHandleResult * result = [[self class] new];
    result.shouldContinueDispatch = shouldContinueDispatch;
    return result;
}

@end
