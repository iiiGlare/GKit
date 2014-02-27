//
//  GUIActionEventHandleResult.h
//  GKitDemo
//
//  Created by Hua Cao on 14-2-17.
//  Copyright (c) 2014年 Hoewo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GUIActionEventHandleResult : NSObject

@property (nonatomic, assign, readonly) BOOL shouldContinueDispatch;

+ (instancetype) resultWithContinueDispatch:(BOOL)shouldContinueDispatch;

@end
