//
//  GUIActionEvent.h
//  GKitDemo
//
//  Created by Hua Cao on 14-2-17.
//  Copyright (c) 2014年 Hoewo. All rights reserved.
//

/*
 界面事件响应对象
 
 类似于Storyboard中的segue,用于显示组件在得到响应后抛出该事件，该事件将在ActionView和ActionController
 组成的结构树中向上传递(按iOS事件传递路径)，首先响应该事件的函数可以决定该事件是否继续向下传递
 
 事件响应机制：
 
 传递中的对象(View/Controller)，定义 handle{ActionName}WithActionEvent: 方法响应改事件
 
 事件命名原则：
 1.保证全局唯一性
 2.每个单词的首字母大写
 */

#import <Foundation/Foundation.h>

@interface GUIActionEvent : NSObject

// 构造函数
+ (instancetype) eventWithName:(NSString *)aName;
+ (instancetype) eventWithName:(NSString *)aName object:(id)anObject;
+ (instancetype) eventWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
- (instancetype) initWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

// 事件名
- (NSString *) name;

// 事件关联对象
- (id) object;

// 事件关联属性
- (NSMutableDictionary *) userInfo;

@end
