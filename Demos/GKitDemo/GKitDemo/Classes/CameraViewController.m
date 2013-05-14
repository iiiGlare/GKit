//
//  CameraViewController.m
//  GKitDemo
//
//  Created by Glare on 13-5-14.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "CameraViewController.h"
#import "GCore.h"
#import "GCamera.h"

@interface CameraViewController ()

@property (nonatomic, strong) GCamera *camera;

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *secondLevelView;

@end

@implementation CameraViewController

#pragma mark - Init && Memory Management
- (void)customInitialize
{
    [super customInitialize];
    
    self.camera = [[GCamera alloc] initWithSessionPreset: GCaptureSessionPresetPhoto
                                   captureDevicePosition: GCaptureDevicePositionBack];
}

- (void)dealloc
{
    [self.camera stopRunning];
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBottomViewHeight:44];
    
    
    [self.contentView addSubviewToFill:self.camera.previewView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubviewToFill:imageView];
    [imageView hide];
    self.imageView = imageView;
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordButton drawBorderWithColor:[UIColor blackColor] width:1 cornerRadius:0];
    [recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [recordButton setTitle:GLocalizedString(@"Take a Photo") forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubviewToFill:recordButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.camera startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.camera stopRunning];
}

#pragma mark - Action
- (void)takePicture
{
    
    UIView *secondLevelView = [[UIView alloc] initWithFrame:self.bottomView.bounds];
    [secondLevelView setBackgroundColor:[UIColor whiteColor]];
    
    //重新拍照
    UIButton *retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retakeButton drawBorderWithColor:[UIColor blackColor] width:1 cornerRadius:0];
    [retakeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [retakeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [retakeButton setTitle:GLocalizedString(@"Retake") forState:UIControlStateNormal];
    [retakeButton addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
    [secondLevelView addSubviewToFill:retakeButton];
    
    [self.bottomView addSubviewToFill:secondLevelView];
    self.secondLevelView = secondLevelView;
    
    CameraViewController * __weak weakSelf = self;
    [self.camera capturePictureWithCallBack:^(UIImage *picture){
        [weakSelf.camera stopRunning];
        [weakSelf.imageView show];
        [weakSelf.imageView setImage:picture];
    }];
}

- (void)retake
{
    [self.camera startRunning];
    [self.imageView setImage:nil];
    [self.imageView hide];
    
    [self.secondLevelView removeFromSuperview];
}

@end
