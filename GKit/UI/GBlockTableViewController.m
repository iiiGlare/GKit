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

#import "GBlockTableViewController.h"

@interface GBlockTableViewController ()

@end

@implementation GBlockTableViewController

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
	if (_blockNumberOfSections) {
		return _blockNumberOfSections(tableView);
	}else{
		return [super numberOfSectionsInTableView:tableView];
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (_blockNumberOfRowsInSection) {
		return _blockNumberOfRowsInSection(tableView, section);
	}else{
		return [super tableView:tableView numberOfRowsInSection:section];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_blockCellForRowAtIndexPath) {
		return _blockCellForRowAtIndexPath(tableView, indexPath);
	}else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_blockDidSelectRowAtIndexPath) {
		_blockDidSelectRowAtIndexPath(tableView, indexPath);
	}else{
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

@end
