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
    

    [self prepareForNewRecording];
}
- (void)prepareForNewRecording
{
    [GAudio prepareRecordingWithCallback:^(NSTimeInterval currentTime, BOOL recording, BOOL interruption, NSError *error)
     {
         UILabel *timeLabel = [[self.contentView subviews] firstObject];
         timeLabel.text = GTimerStringFromTimeInterval(currentTime);
         if (interruption) {
             [GAudio pauseRecording];
         }else {
             if (!recording) {
                 [GAudio startRecording];
             }
         }
     }];
}
- (void)recording:(UIButton *)sender
{
    NSURL *fileURL = [GDocumentsDirectoryURL() URLByAppendingPathComponent:@"audio.caf"];
    
    if (sender.tag == 0) {
        [GAudio startRecording];
        sender.tag = 1;
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = sender.bounds;
        button.y = self.contentView.height - button.height;
        button.tag = 0;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button setTitle:@"暂停并播放" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stopAndPreview:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
 
        
    }else if (sender.tag==1) {
        [self.contentView removeAllSubviewOfClass:[UIButton class]];
        [GAudio stopAndMoveRecordedAudioFileToURL:fileURL];
        [self performSelectorInBackground:@selector(prepareForNewRecording) withObject:nil];
        sender.tag = 2;
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }else if (sender.tag==2) {
        [GAudio playAudioWithContentsOfURL:fileURL volume:1.0];
        sender.tag = 0;
        [sender setTitle:@"录音" forState:UIControlStateNormal];
    }
}

- (void)stopAndPreview:(UIButton *)sender
{
    if (sender.tag == 0) {
        [GAudio pauseRecording];
        [GAudio playAudioWithContentsOfURL:GAudioRecordingFileURL() volume:1.0];
        [sender setTitle:@"继续" forState:UIControlStateNormal];
        sender.tag = 1;
    }else {
        [GAudio stopPlayAudio];
        [GAudio startRecording];
        [sender setTitle:@"暂停并播放" forState:UIControlStateNormal];
        sender.tag = 0;
    }
}

@end
