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

@interface GTabBarController : UITabBarController

/**
 * names 为视图控制器的名字
 * title、image 根据 name, 自动得出
 * 例如：TabBarController容器内的ViewController为：CustomViewController MyViewController
 * 则：
 *		names = @[@"Custom", @"My"];
 * 对应的title为：Custom-title My-title，需要在本地化文件中做对应的翻译
 * 对应的image为：Custom-image.png My-image.png
 */
+ (id)newWithControllerNames:(NSArray *)names;

@end
