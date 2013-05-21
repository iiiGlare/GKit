//
//  UITableViewCell+GKit.h
//  GKitDemo
//
//  Created by Hua Cao on 13-5-21.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (GKit)

@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, weak, readonly) NSIndexPath *indexPath;

@end
