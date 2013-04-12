//
//  MyTableViewController.m
//  GKitDemo
//
//  Created by Hua Cao on 13-3-17.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "MyTableViewController.h"

@implementation MyTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MyTableViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.topView setBackgroundColor:[UIColor redColor]];
//    [self.bottomView setBackgroundColor:[UIColor blueColor]];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    int i = arc4random() % 3;
//    if (i==0) {
//        [self setTopViewHeight:0];
//        [self setBottomViewHeight:0];
//    }else if (i==1) {
//        [self setTopViewHeight:40];
//        [self setBottomViewHeight:0];
//    }else {
//        [self setTopViewHeight:0];
//        [self setBottomViewHeight:40];
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([self hasAdditionalCell]) {
		return 3;
	}else{
		return 2;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self isAdditionalCellAtIndexPath:indexPath]) {
		[self removeAdditionalCell];
	}else {
		if (![self hasAdditionalCell]) {
			[self insertAdditionalCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
		}
	}
}

@end
