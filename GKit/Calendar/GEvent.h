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

@property (nonatomic, copy) NSDate *beginDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *title;

@end
