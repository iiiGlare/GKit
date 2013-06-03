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
#import "GPicker.h"
@interface CustomUIViewController ()
<
 GPickerDataSource, GPickerDelegate
>

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

    [self showPicker];
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

#pragma mark - Picker 
- (void)showPicker
{
    GPicker * picker = [[GPicker alloc] initWithFrame:CGRectMake(10, 80, 283, 197)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.contentEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0);
    picker.backgroundImage = [GImageNamed(@"picker_background.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    picker.separatorLineImage = GImageNamed(@"picker_separator.png");
    picker.separatorLineSize = CGSizeMake(1, 191);
    picker.indicatorImage = GImageNamed(@"picker_indicator.png");
    [self.view addSubview:picker];
    [picker reloadAllComponents];
    
    [picker selectRow:1 inComponent:0 animated:NO];
    [picker selectRow:2 inComponent:1 animated:NO];
    [picker selectRow:3 inComponent:2 animated:NO];
    
    GPRINT(@"component %d: selected row %d", 0, [picker selectedRowInComponent:0]);
    GPRINT(@"component %d: selected row %d", 1, [picker selectedRowInComponent:1]);
    GPRINT(@"component %d: selected row %d", 2, [picker selectedRowInComponent:2]);
}
- (NSInteger)numberOfComponentsInPicker:(GPicker *)picker
{
    return 3;
}
- (NSInteger)picker:(GPicker *)picker numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 12;
        case 1:
            return 31;
        default:
            return 5;
    }
}
- (CGFloat)picker:(GPicker *)picker rowHeightForComponent:(NSInteger)component
{
    return 42;
}
- (CGFloat)picker:(GPicker *)picker widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 108;
        case 1:
            return 76.5;
        default:
            return picker.width-108-76.5;
    }
}
- (void)picker:(GPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    GPRINT(@"component:%d row:%d",component,row);
}
@end
