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
@property (nonatomic, strong) UITableView *tableView;
- (id)initWithStyle:(UITableViewStyle)style;


////
//cell input field
////
@property (nonatomic, strong) UITextField *cellInputField;
@property (nonatomic, strong) NSIndexPath *cellInputFieldIndexPath;
- (void)addCellInputFieldAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeCellInputField;

- (void)showCellInputField;
- (void)hideCellInputField;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

- (Class)cellInputFieldClass;
- (void)cellInputFieldDidLoad:(UITextField *)textField;
- (void)cellInputFieldWillAddAtIndexPath:(NSIndexPath *)indexPath;
- (void)cellInputFieldDidAddAtIndexPath:(NSIndexPath *)indexPath;
- (void)cellInputFieldWillRemoveFromIndexPath:(NSIndexPath *)indexPath;
- (void)cellInputFieldDidRemoveFromIndexPath:(NSIndexPath *)indexPath;

@end

