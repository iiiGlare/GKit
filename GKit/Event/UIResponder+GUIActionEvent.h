//
//  UIResponder+GUIActionEvent.h
//  GKitDemo
//
//  Created by Hua Cao on 14-2-17.
//  Copyright (c) 2014年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUIActionEvent.h"
#import "GUIActionEventHandleResult.h"

@interface UIResponder (GUIActionEvent)

/**
 * 分发界面事件
 *
 * 想要处理该事件的对象，需要实现形如：
 *  - (GUIActionEventHandleResult *)handle%@WithActionEvent:(GUIActionEvent *)actionEvent;
 *
 * %@ 为事件名，首字母将自动转为大写
 * 返回对象为 nil, 或者返回对象的 continueDispatch 属性为 NO 时，表示该事件处理结束，不再传递该事件
 */
- (void) dispatchGUIActionEvent:(GUIActionEvent *)actionEvent;

@end
