//
//  GUIActionEvent.m
//  GKitDemo
//
//  Created by Hua Cao on 14-2-17.
//  Copyright (c) 2014年 Hoewo. All rights reserved.
//

#import "GUIActionEvent.h"

@interface GUIActionEvent ()

@property (nonatomic, copy) NSString * name;
@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSMutableDictionary * userInfo;

@end

@implementation GUIActionEvent

+ (instancetype) eventWithName:(NSString *)aName
{
    return [[GUIActionEvent alloc] initWithName:aName object:nil userInfo:nil];
}

+ (instancetype) eventWithName:(NSString *)aName object:(id)anObject
{
    return [[GUIActionEvent alloc] initWithName:aName object:anObject userInfo:nil];
}

+ (instancetype) eventWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    return [[GUIActionEvent alloc] initWithName:aName object:anObject userInfo:aUserInfo];
}

- (instancetype) initWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    self = [super init];
    if (self) {
        self.name = aName;
        self.object = anObject;
        self.userInfo = [NSMutableDictionary dictionary];
        [self.userInfo addEntriesFromDictionary:aUserInfo];
    }
    return self;
}

@end
