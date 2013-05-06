//
//  CustomUIViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "CustomUIViewController.h"

@interface CustomUIViewController ()

@end

@implementation CustomUIViewController

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
	
	UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    doubleTapGR.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGR];
    
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOn)];
    singleTapGR.numberOfTapsRequired = 1;
    [singleTapGR requireGestureRecognizerToFail:doubleTapGR];
    [self.view addGestureRecognizer:singleTapGR];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goOn
{
    [self.navigationController pushViewController:[CustomUIViewController new] animated:YES];
}
- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
