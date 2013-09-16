//
//  GEvent.h
//  CalendarDemo
//
//  Created by Glare on 13-4-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGEvent @"GEvent"

@interface GEvent : NSObject

@property (nonatomic, strong) id userObject;

@property (nonatomic, copy) NSDate * beginTime;
@property (nonatomic, copy) NSDate * endTime;
@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) UIColor * borderColor;
@property (nonatomic, copy) UIColor * backgroundColor;
@property (nonatomic, copy) UIColor * foregroundColor;

@property (nonatomic, assign) BOOL isLongPresAdded;

@end
