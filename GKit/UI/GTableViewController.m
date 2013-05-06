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

#import "GTableViewController.h"
#import "GCore.h"
#import "GTextField.h"

@interface GTableViewController ()

@end

@implementation GTableViewController

#pragma mark - Init & Memory Management

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_tableViewStyle = style;
	}
	return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.tableView==nil)
    {
        _tableView = [[UITableView alloc] initWithFrame: self.contentView.bounds
                                                  style: _tableViewStyle];
        _tableView.autoresizingMask = GViewAutoresizingFlexibleSize;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.contentView addSubview:_tableView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
	if ([_cellInputField isFirstResponder]) {
		[_cellInputField resignFirstResponder];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.tableView = nil;
    self.cellInputField = nil;
    self.cellInputFieldIndexPath = nil;
}

#pragma mark - Action
- (void)reloadData
{
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self cellForTableView:tableView atIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

//create cell
- (UITableViewCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return cell;
}

//configure cell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	[cell.textLabel setText:[NSString stringWithFormat:@"Section-%d Row-%d",indexPath.section,indexPath.row]];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Title Text Field

- (UITextField *)cellInputField
{
	if (_cellInputField) {
		return _cellInputField;
	}
	
	_cellInputField = [[[self cellInputFieldClass] alloc] initWithFrame:CGRectZero];
	_cellInputField.backgroundColor = [UIColor whiteColor];
	_cellInputField.delegate = self;
	[self cellInputFieldDidLoad:_cellInputField];
    
	return _cellInputField;
}

- (void)addCellInputFieldAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellInputFieldIndexPath = indexPath;
    
    [self cellInputFieldWillAddAtIndexPath:indexPath];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell.contentView addSubview:self.cellInputField];
    [self showCellInputField];
	[self.cellInputField becomeFirstResponder];
    [self cellInputFieldDidAddAtIndexPath:indexPath];
}

- (void)removeCellInputField
{
    [self cellInputFieldWillRemoveFromIndexPath:self.cellInputFieldIndexPath];
	[self.cellInputField resignFirstResponder];
	[self.cellInputField removeFromSuperview];
    [self cellInputFieldDidRemoveFromIndexPath:self.cellInputFieldIndexPath];
    
    self.cellInputFieldIndexPath = nil;
}

- (void)showCellInputField
{
    [self.cellInputField show];
}
- (void)hideCellInputField
{
    [self.cellInputField hide];
}


//Override by Subclass
- (CGFloat)tableViewBottomAdditionForKeyboard{return 0;}

- (Class)cellInputFieldClass{return [GTextField class];}
- (void)cellInputFieldDidLoad:(UITextField *)textField{}

- (void)cellInputFieldWillAddAtIndexPath:(NSIndexPath *)indexPath{}
- (void)cellInputFieldDidAddAtIndexPath:(NSIndexPath *)indexPath{}

- (void)cellInputFieldWillRemoveFromIndexPath:(NSIndexPath *)indexPath{}
- (void)cellInputFieldDidRemoveFromIndexPath:(NSIndexPath *)indexPath{}

#pragma mark - KeyboardNotification
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeShown:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	
}

- (void)unregisterForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	CGFloat kbHeight = kbSize.height;
	CGFloat bottomEdgeInset = kbHeight - [self tableViewBottomAdditionForKeyboard];
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomEdgeInset, 0);
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, bottomEdgeInset, 0);
	[self.tableView scrollRectToVisible:[self.tableView convertRect:self.cellInputField.frame fromView:self.cellInputField.superview] animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	self.tableView.contentInset = UIEdgeInsetsZero;
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - Additional Cell

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.expandedCellIndexPath])
	{
		[self collapseExpandedCell];
		
	}else {
        
		[self collapseExpandedCell];
		
		self.expandedCellIndexPath = indexPath;
		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
}

- (void)collapseExpandedCell
{
    if (self.expandedCellIndexPath)
	{
		NSIndexPath *preExpandCellIndexPath = self.expandedCellIndexPath;
		self.expandedCellIndexPath = nil;
		[self.tableView reloadRowsAtIndexPaths:@[preExpandCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


@end