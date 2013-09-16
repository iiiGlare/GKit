//
//  SelectionTableViewController.m
//  GKitDemo
//
//  Created by Hua Cao on 13-9-16.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "SelectionTableViewController.h"

@interface SelectionTableViewController ()

@end

@implementation SelectionTableViewController

+ (id)new {
    SelectionTableViewController * new = [[SelectionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    NSMutableArray * items = [NSMutableArray array];
    for (int i=1;i<=100;i++) {
        [items addObject:[NSString stringWithFormat:@"%d", i]];
    }
    new.itemsForSelection = items;
    new.scrollItem = [NSString stringWithFormat:@"%d", 50];
    return new;
}

@end
