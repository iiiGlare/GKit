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
#import "GTextView.h"

@interface GTableViewController ()

@end

@implementation GTableViewController

#pragma mark - Init & Memory Management

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

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
        self.tableView = [[UITableView alloc] initWithFrame: self.contentView.bounds
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.tableView = nil;
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
	UITableViewCell *cell = nil;
	if ([indexPath isEqual:self.expandedCellIndexPath]) {
		cell = [self expandedCellForTableView:tableView atIndexPath:indexPath];
		[self configureExpandedCell:cell atIndexPath:indexPath];
		return cell;
	}else {
		cell = [self cellForTableView:tableView atIndexPath:indexPath];
		[self configureCell:cell atIndexPath:indexPath];
		return cell;
	}
    
	return cell;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell==nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.textLabel setText:[NSString stringWithFormat:@"Cell Section-%d Row-%d",indexPath.section,indexPath.row]];
}

- (UITableViewCell *)expandedCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExpandedCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell==nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	return cell;
}

- (void)configureExpandedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.textLabel setText:[NSString stringWithFormat:@"ExpandedCell Section-%d Row-%d",indexPath.section,indexPath.row]];
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - KeyboardNotification

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	CGFloat kbHeight = kbSize.height;
	CGRect tableViewRect = [GApplicationMainWindow() convertRect:self.tableView.frame fromView:self.tableView.superview];
	CGFloat bottomEdgeInset = kbHeight - (GApplicationMainWindow().height - CGRectGetMaxY(tableViewRect));
	
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomEdgeInset, 0);
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, bottomEdgeInset, 0);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	[UIView animateWithDuration:0.25
					 animations:^{
						 self.tableView.contentInset = UIEdgeInsetsZero;
						 self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
					 }];
}

#pragma mark - Expand and Collapse Cell

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