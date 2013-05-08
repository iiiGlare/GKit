//
//  AudioViewController.m
//  GKitDemo
//
//  Created by Glare on 13-5-9.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "AudioViewController.h"
#import "GCore.h"
#import "GAudio.h"
@interface AudioViewController ()

@end

@implementation AudioViewController

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
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignmentG = GTextAlignmentCenter;
    timeLabel.text = GTimerStringFromTimeInterval(0);
    timeLabel.center = self.contentView.innerCenter;
    timeLabel.autoresizingMask = GViewAutoresizingFlexibleMargins;
    [self.contentView addSubview:timeLabel];

    [self setBottomViewHeight:60];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitle:@"录制" forState:UIControlStateNormal];
    [self.bottomView addSubviewToFill:button];
    [button addTarget:self action:@selector(recording:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)recording:(UIButton *)sender
{
    NSURL *fileURL = [GDocumentsDirectoryURL() URLByAppendingPathComponent:@"audio.caf"];
    
    if (sender.tag == 0) {
        [GAudio recordAudioAtURL:fileURL];
        sender.tag = 1;
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    }else if (sender.tag==1) {
        [GAudio stopRecording];
        sender.tag = 2;
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }else if (sender.tag==2) {
        [GAudio playMusicWithContentsOfURL:fileURL volume:1.0];
        sender.tag = 0;
        [sender setTitle:@"录音" forState:UIControlStateNormal];
    }
}

@end
