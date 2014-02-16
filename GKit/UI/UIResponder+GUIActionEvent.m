//
//  UIResponder+GUIActionEvent.m
//  GKitDemo
//
//  Created by Hua Cao on 14-2-17.
//  Copyright (c) 2014年 Hoewo. All rights reserved.
//

#import "UIResponder+GUIActionEvent.h"
#import <objc/message.h>

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
    if (next) {
        [next dispatchGUIActionEvent:actionEvent];
    }
}


@end
