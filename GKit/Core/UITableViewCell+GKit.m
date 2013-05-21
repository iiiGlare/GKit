//
//  UITableViewCell+GKit.m
//  GKitDemo
//
//  Created by Hua Cao on 13-5-21.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "UITableViewCell+GKit.h"
#import "UIView+GKit.h"

@implementation UITableViewCell (GKit)

@dynamic tableView;
@dynamic indexPath;

- (UITableView *)tableView
{
	return (UITableView *)[self superviewOfClass:[UITableView class]];
}

- (NSIndexPath *)indexPath
{
	return [self.tableView indexPathForCell:self];
}

@end
