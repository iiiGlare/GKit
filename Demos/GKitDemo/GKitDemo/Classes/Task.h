//
//  Task.h
//  GKitDemo
//
//  Created by Hua Cao on 13-3-19.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;

@end
