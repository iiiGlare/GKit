//
//  CustomUIViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "CustomUIViewController.h"
#import "GCore.h"
#import "GSwitch.h"
#import "GScrollSlider.h"
#import "GPicker.h"
#import "GDatePicker.h"
#import "GBorderView.h"
#import <QuartzCore/QuartzCore.h>

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
	
    [self showSwitch];
    
    [self showScrollSlider];

    [self showPicker];
    
    [self showBorderView];
}

#pragma mark - 
- (void)showSwitch {
    
    GSwitch *gSwitch = [[GSwitch alloc] initWithFrame: CGRectMake(10, 10, 80, 27)
                                            knobImage: GImageNamed(@"switch_knob.png")
                                        onToggleImage: [GImageNamed(@"switch_on_background.png") resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)]
                                       offToggleImage: [GImageNamed(@"switch_off_background.png") resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)]];
    [self.view addSubview:gSwitch];
}

#pragma mark -
- (void)showScrollSlider
{
    GScrollSlider *scrollSlider = [[GScrollSlider alloc] initWithFrame:CGRectMake(10, 60, 300, 50)];
	scrollSlider.thumbImage = [UIImage imageNamed:@"thumb.png"];
	scrollSlider.minTrackImage = [[UIImage imageNamed:@"min_track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	scrollSlider.maxTrackImage = [[UIImage imageNamed:@"max_track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	scrollSlider.trackViewHeight = 8;
	scrollSlider.backgroundColor = [UIColor redColor];
	scrollSlider.scalesView.backgroundColor = [UIColor clearColor];
    
    scrollSlider.minTrackView.layer.cornerRadius = 4;
    scrollSlider.minTrackView.clipsToBounds = YES;
    
    [scrollSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:scrollSlider];
    
    [scrollSlider reloadSlider];
}

- (void)sliderValueChanged:(GScrollSlider *)slider
{
    GPRINT(@"%.1f",slider.value);
}

#pragma mark - Picker 
- (void)showPicker
{
    GDatePicker * datePicker = [[GDatePicker alloc] initWithFrame:CGRectMake(27, 120, 266, 106)];
    datePicker.backgroundColor = [UIColor redColor];
    datePicker.datePickerStyle = GDatePickerStyleDateTime;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
//    GPicker * picker = [[GPicker alloc] initWithFrame:CGRectMake(10, 120, 283, 197)];
//    picker.dataSource = self;
//    picker.delegate = self;
//    picker.contentEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0);
//    picker.backgroundImage = [GImageNamed(@"picker_background.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    picker.separatorLineImage = GImageNamed(@"picker_separator.png");
//    picker.separatorLineSize = CGSizeMake(1, 191);
//    picker.indicatorImage = GImageNamed(@"picker_indicator.png");
//    picker.rowHeight = 42;
//    [self.view addSubview:picker];
//    [picker reloadAllComponents];
//    
//    [picker selectRow:0 inComponent:0 animated:NO];
//    [picker selectRow:2 inComponent:1 animated:NO];
//    [picker selectRow:3 inComponent:2 animated:NO];
//    
//    GPRINT(@"component %d: selected row %d", 0, [picker selectedRowInComponent:0]);
//    GPRINT(@"component %d: selected row %d", 1, [picker selectedRowInComponent:1]);
//    GPRINT(@"component %d: selected row %d", 2, [picker selectedRowInComponent:2]);
}

- (void)datePickerValueChanged:(GDatePicker *)datePicker {
    GPRINT(@"%@", datePicker.selectedDate);
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

- (void)picker:(GPicker *)picker didScrollCell:(UIView *)cell inComponent:(NSInteger)component atOffset:(CGFloat)offset {
    CGFloat scale = 1.0 - (ABS(offset)/4);
    cell.transform = CGAffineTransformMakeScale(scale, scale);
}

- (BOOL)picker:(GPicker *)picker selectableForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row<5) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark - 
- (void)showBorderView {
    GBorderView * borderView = [[GBorderView alloc] initWithFrame:CGRectMake(10, 236, 300, 50)];
    borderView.fillColor = [UIColor whiteColor];
    borderView.borderColor = [UIColor blackColor];
    borderView.shadowColor = [UIColor redColor];
    borderView.shadowOffset = CGSizeMake(1, 1);
    borderView.borderWidth = 1;
    [self.contentView addSubview:borderView];
}

@end
