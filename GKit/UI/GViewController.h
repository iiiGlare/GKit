//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <UIKit/UIKit.h>

enum {
    GPresentAnimationTypNormal,
    GPresentAnimationTypeHide
};
typedef NSInteger GPresentAnimationType;


@interface GViewController : UIViewController

- (void)customInitialize;

@property (nonatomic, copy) void (^blockCallBack)(id);

// View
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
- (void)setTopViewHeight:(CGFloat)topViewHeight;
- (void)setContentViewHeight:(CGFloat)contentViewHeight;
- (void)setBottomViewHeight:(CGFloat)bottomViewHeight;

// Present / Dismiss Animation
@property (nonatomic) BOOL canDragDismiss;  //default YES
@property (nonatomic, assign) GPresentAnimationType presentAnimationType;

// Navigation Control
- (void)willPop;

// Keyboard
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWillBeShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

@end
