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
#import "GViewController.h"

@interface GTableViewController : GViewController
<
 UITableViewDataSource, UITableViewDelegate,
 UITextFieldDelegate, UITextViewDelegate
>
{
@private
	UITableViewStyle _tableViewStyle;
	
}

//table view
@property (nonatomic, strong) IBOutlet UITableView *tableView;
- (id)initWithStyle:(UITableViewStyle)style;

- (void)reloadData;

/**
 * 子类不要直接重写DataSource方法---tableView:cellForRowAtIndexPath: ，替代的：
 *
 * 子类重写以下方法，创建cell
 *		cellForTableView:atIndexPath:
 *
 * 子类重写以下方法，配置cell
 *		configureCell:atIndexPath:
 */
- (UITableViewCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


#pragma mark - Keyboard
/**
 * 子类可以重写 tableViewBottomAdditionForKeyboard 来调整键盘弹出后 tableView 的可视区域
 */
- (CGFloat)tableViewBottomAdditionForKeyboard;


- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWillBeShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;


#pragma mark - Expand and Collapse Cell

@property (nonatomic, strong) NSIndexPath *expandedCellIndexPath;

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)collapseExpandedCell;

- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)configureExpandedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

