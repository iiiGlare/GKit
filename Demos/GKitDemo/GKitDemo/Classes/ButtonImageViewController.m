//
//  ButtonImageViewController.m
//  GKitDemo
//
//  Created by Hua Cao on 13-11-7.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "ButtonImageViewController.h"
#import "GCore.h"

@interface ButtonImageViewController ()

@end

@implementation ButtonImageViewController

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
    
    //
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithSize:CGSizeMake(44, 44)
                                      backgroundColor:GRandomColor()]
                      forState:UIControlStateNormal];
    [button sizeToFit];
    [self.view addSubview:button];
    button.origin = CGPointMake(10, 100);
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithSize:CGSizeMake(44, 44)
                                          borderWidth:1.0f/GScreenScale
                                          borderColor:GRandomColor()
                                      backgroundColor:GRandomColor()]
                      forState:UIControlStateNormal];
    [button sizeToFit];
    [self.view addSubview:button];
    button.origin = CGPointMake(60, 100);

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithSize:CGSizeMake(44, 44)
                                         cornerRadius:3
                                      backgroundColor:GRandomColor()]
                      forState:UIControlStateNormal];
    [button sizeToFit];
    [self.view addSubview:button];
    button.origin = CGPointMake(110, 100);
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithSize:CGSizeMake(44, 44)
                                         cornerRadius:3.0f
                                          borderWidth:1.0f/GScreenScale
                                          borderColor:GRandomColor()
                                      backgroundColor:GRandomColor()]
                      forState:UIControlStateNormal];
    [button sizeToFit];
    [self.view addSubview:button];
    button.origin = CGPointMake(160, 100);
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithSize:CGSizeMake(44, 44)
                                         cornerRadius:3.0f
                                          borderWidth:1.0f/GScreenScale
                                          borderColor:GRandomColor()
                                     backgroundColors:@[[UIColor whiteColor],[UIColor blackColor]]]
                      forState:UIControlStateNormal];
    [button sizeToFit];
    [self.view addSubview:button];
    button.origin = CGPointMake(210, 100);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
