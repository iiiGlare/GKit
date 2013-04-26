//
//  PresentViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-26.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "PresentViewController.h"
#import "GCore.h"
#import "GNavigationViewController.h"

@interface PresentViewController ()
@property (nonatomic, strong) UIViewController *superController;
@end

@implementation PresentViewController

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.center = [self.contentView innerCenter];
    [button setTintColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(presentOrDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    if (self.presentingViewController) {
        [button setTitle:@"Dismiss" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"Present" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentOrDismiss:(UIButton *)button
{
    if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Present"]) {
        PresentViewController *vc = [PresentViewController new];
        [self presentViewController: [[GNavigationViewController alloc] initWithRootViewController:vc]
                           animated: YES
                         completion: ^{
                             GPRINT(@"present completion");
                         }];
    }else {
        [self dismissViewControllerAnimated: YES
                                 completion: ^{
                                     GPRINT(@"dismiss completion");
                                 }];
    }
}

@end
