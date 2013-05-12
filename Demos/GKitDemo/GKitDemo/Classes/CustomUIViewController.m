//
//  CustomUIViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "CustomUIViewController.h"
#import "GCore.h"
#import "GScrollSlider.h"
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
    
    [self showScrollSlider];

}


#pragma mark - 
- (void)showScrollSlider
{
    GScrollSlider *scrollSlider = [[GScrollSlider alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
	scrollSlider.thumbImage = [UIImage imageNamed:@"thumb.png"];
	scrollSlider.minTrackImage = [[UIImage imageNamed:@"min_track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	scrollSlider.maxTrackImage = [[UIImage imageNamed:@"max_track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	scrollSlider.trackViewHeight = 8;
	scrollSlider.backgroundColor = [UIColor clearColor];
	scrollSlider.scalesView.backgroundColor = [UIColor clearColor];
    [scrollSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:scrollSlider];
}

- (void)sliderValueChanged:(GScrollSlider *)slider
{
    GPRINT(@"%.1f",slider.value);
}

@end
