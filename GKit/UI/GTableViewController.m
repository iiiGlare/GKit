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

@interface GTableViewController ()

@end

@implementation GTableViewController

#pragma mark - Init & Memory Management

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super init];
	if (self) {
		_tableViewStyle = style;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Life Cycle

- (void)loadView
{
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UITableView *tv = [[UITableView alloc] initWithFrame:view.bounds style:_tableViewStyle];
	tv.autoresizingMask = GViewAutoresizingFlexibleSize;
	tv.dataSource = self;
	tv.delegate = self;
	[view addSubview:tv];
	self.tableView = tv;
	
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.tableView = nil;
    self.cellInputField = nil;
    self.cellInputFieldIndexPath = nil;
    [self unregisterForKeyboardNotifications];
}

#pragma mark UITableViewDataSource

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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell.textLabel setText:@"test"];
    
    return cell;
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
    self.cellInputField.hidden = NO;
}
- (void)hideCellInputField
{
    self.cellInputField.hidden = YES;
}


//Override by Subclass
- (Class)cellInputFieldClass{
    return [UITextField class];
}
- (void)cellInputFieldDidLoad:(UITextField *)textField{
}

- (void)cellInputFieldWillAddAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)cellInputFieldDidAddAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)cellInputFieldWillRemoveFromIndexPath:(NSIndexPath *)indexPath{
}
- (void)cellInputFieldDidRemoveFromIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - KeyboardNotification
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	
}

- (void)unregisterForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	CGFloat kbHeight = kbSize.height;
	
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbHeight, 0);
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbHeight, 0);
	[self.tableView scrollRectToVisible:[self.tableView convertRect:self.cellInputField.frame fromView:self.cellInputField.superview] animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	self.tableView.contentInset = UIEdgeInsetsZero;
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}


#pragma mark - Additional Cell
- (void)insertAdditionalCellAtIndexPath:(NSIndexPath *)indexPath
{
	self.additionalCellIndexPath = indexPath;
		
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
	[self.tableView endUpdates];
}
- (void)removeAdditionalCell
{
	NSIndexPath *indexPath = self.additionalCellIndexPath;
	self.additionalCellIndexPath = nil;
	
	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
	[self.tableView endUpdates];
}

//
- (BOOL)hasAdditionalCell
{
	if (self.additionalCellIndexPath) {
		return YES;
	}else {
		return NO;
	}
}
- (BOOL)isAdditionalCellAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath isEqual:self.additionalCellIndexPath]) {
		return YES;
	}else{
		return NO;
	}
}
@end