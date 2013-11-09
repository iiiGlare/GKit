//
//  HomeViewController.m
//  FreeMove
//
//  Created by Glare on 13-4-12.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "HomeViewController.h"
#import "CatsViewController.h"
#import "DogsViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong) CatsViewController *catsViewController;
@property (nonatomic, strong) DogsViewController *dogsViewController;
@end

@implementation HomeViewController

- (void)loadView
{
    self.view = [[GMoveScene alloc] initWithFrame:GScreenBounds()];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _catsViewController = [CatsViewController new];
    _catsViewController.view.backgroundColor = GRandomColor();
    _dogsViewController = [DogsViewController new];
    _dogsViewController.view.backgroundColor = GRandomColor();
    
    [self setTopViewHeight:100];
    [self setBottomViewHeight:100];
    [self.topView addSubviewToFill:_catsViewController.view];
    [self.bottomView addSubviewToFill:_dogsViewController.view];
    
}


@end
