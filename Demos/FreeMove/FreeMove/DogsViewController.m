//
//  DogsViewController.m
//  FreeMove
//
//  Created by Glare on 13-4-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "DogsViewController.h"


@interface DogsViewController ()

@end

@implementation DogsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (GMoveSnapshot *)prepareSnapshotForSprite:(NaughtyLabel *)sprite
{
    GMoveSnapshot *snapshot = [[GMoveSnapshot alloc] initWithFrame:sprite.bounds];
    [snapshot addSubviewToFill:sprite];
    return snapshot;
}

- (void)didPrepareSnapshotForSprite:(NaughtyLabel *)sprite
{
    [sprite setText:@"I will change"];
}

- (void)isCatchingSnapshot:(GMoveSnapshot *)snapshot
{
    [(NaughtyLabel *)snapshot.sprite setText:@"Dog or Cat?"];
}

- (void)didCatchSnapshot:(GMoveSnapshot *)snapshot
{
    [(NaughtyLabel *)snapshot.sprite setText:@"I am a Dog"];
    [self.view addSubview:snapshot.sprite];
    CGPoint center = [self.view convertPoint:snapshot.center fromView:snapshot.superview];
    if (!CGRectContainsPoint(self.view.bounds, center)) {
        center = [self.view innerCenter];
    }
    [snapshot.sprite setCenter:center];
}

@end
