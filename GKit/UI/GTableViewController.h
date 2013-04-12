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
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
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



#pragma mark - cell input field

@property (nonatomic, strong) UITextField *cellInputField;
@property (nonatomic, strong) NSIndexPath *cellInputFieldIndexPath;
/**
 * 子类调用以下方法，加载输入框到cell上
 *		addCellInputFieldAtIndexPath:
 * 子类调用以下方法，移除输入框
 *		removeCellInputField
 */
- (void)addCellInputFieldAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeCellInputField;

/**
 * 子类调用以下方法，显示输入框
 *		showCellInputField
 * 子类调用以下方法，隐藏输入框
 *		hideCellInputField
 */
- (void)showCellInputField;
- (void)hideCellInputField;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

/**
 * 子类可以重写以下方法，配置输入框
 */
- (Class)cellInputFieldClass;
- (void)cellInputFieldDidLoad:(UITextField *)textField;
- (void)cellInputFieldWillAddAtIndexPath:(NSIndexPath *)indexPath;
- (void)cellInputFieldDidAddAtIndexPath:(NSIndexPath *)indexPath;
- (void)cellInputFieldWillRemoveFromIndexPath:(NSIndexPath *)indexPath;
- (void)cellInputFieldDidRemoveFromIndexPath:(NSIndexPath *)indexPath;

#pragma mark - additional cell

@property (nonatomic, strong) NSIndexPath *additionalCellIndexPath;
/**
 * 子类调用以下方法插入附加cell
 *		insertAdditionalCellAtIndexPath:
 * 子类调用以下方法移除附加cell
 *		removeAdditionalCell
 */
- (void)insertAdditionalCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeAdditionalCell;

/**
 * 子类调用以下方法判断当前是否存在附加cell
 *		hasAdditionalCell
 * 子类调用以下方法判断某cell是否为附加cell
 *		isAdditionalCellAtIndexPath:
 */
- (BOOL)hasAdditionalCell;
- (BOOL)isAdditionalCellAtIndexPath:(NSIndexPath *)indexPath;

@end

