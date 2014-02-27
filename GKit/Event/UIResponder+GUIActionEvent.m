//
//  UIResponder+GUIActionEvent.m
//  GKitDemo
//
//  Created by Hua Cao on 14-2-17.
//  Copyright (c) 2014年 Hoewo. All rights reserved.
//

#import "UIResponder+GUIActionEvent.h"
#import <objc/message.h>
#import "GCore.h"

@implementation UIResponder (GUIActionEvent)

// 分发事件
- (void) dispatchGUIActionEvent:(GUIActionEvent *)actionEvent
{
    NSString * name = [[[actionEvent.name substringToIndex:1] uppercaseString] stringByAppendingString:[actionEvent.name substringFromIndex:1]];
    NSString * actionSelectorName = [NSString stringWithFormat:@"handle%@WithActionEvent:", name];
    SEL sel = NSSelectorFromString(actionSelectorName);
    if ([self respondsToSelector:sel]) {
        GUIActionEventHandleResult * result = objc_msgSend(self, sel, actionEvent);
        if (result == nil ||
            ![result isKindOfClass:[GUIActionEventHandleResult class]] ||
            result.shouldContinueDispatch == NO) {
            return;
        }
    }
    
    UIResponder * next = [self nextResponder];
    if (next == nil && [self isKindOfClass:[UIViewController class]]) {
        next = [(UIViewController *)self parentViewController];
    }
    if (next) {
        [next dispatchGUIActionEvent:actionEvent];
    }
    else {
        GPRINT(@"分发 BDUIActionEvent 事件失败， 没有找到实现 %@ 的对象", actionSelectorName);
    }
}


@end
