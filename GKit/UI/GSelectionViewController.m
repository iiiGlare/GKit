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

#import "GSelectionViewController.h"

//GSelectionBasicItem
@implementation GSelectionBasicItem
@end

//GSelectionViewController
@interface GSelectionViewController ()

@end

@implementation GSelectionViewController

#pragma mark - Init 
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _scrollPosition = UITableViewScrollPositionMiddle;
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_scrollItem &&
        [_itemsForSelection containsObject:_scrollItem]) {
        NSIndexPath * scrollIndexPath = [NSIndexPath indexPathForRow:[_itemsForSelection indexOfObject:_scrollItem]
                                                           inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath
                              atScrollPosition:_scrollPosition
                                      animated:NO];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.itemsForSelection count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	// Configure the cell...
    if (indexPath.row>=0 && indexPath.row<[self.itemsForSelection count]) {
        id item = [self.itemsForSelection objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[NSString class]]) {
            [cell.textLabel setText:item];
        }else{
            [cell.textLabel setText:@"test"];
        }
    }else{
        [cell.textLabel setText:@"test"];
    }

}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_blockDidSelect) {
        _blockDidSelect([self.itemsForSelection objectAtIndex:indexPath.row]);
    }
}

@end
