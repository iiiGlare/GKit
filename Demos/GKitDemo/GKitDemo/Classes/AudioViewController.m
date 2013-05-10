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
@property (nonatomic, strong) GAudio *audio;
@end

@implementation AudioViewController

- (void)dealloc
{
    [self.audio deletePlaying];
    [self.audio deleteRecording];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.audio = [GAudio newAudio];
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
    
    AudioViewController * __weak weakSelf = self;
    [self.audio prepareRecordingWithCallback:^(GAudio *audio, GAudioInterruptionType type, NSError *error)
     {
         UILabel *timeLabel = [[weakSelf.contentView subviews] firstObject];
         timeLabel.text = GTimerStringFromTimeInterval(audio.recorder.currentTime);
         if (type==GAudioInterruptionBegin) {
             [audio pauseRecording];
         }
     }];
}
- (void)recording:(UIButton *)sender
{
    NSURL *fileURL = [GDocumentsDirectoryURL() URLByAppendingPathComponent:@"audio.caf"];
    
    if (sender.tag == 0) {
        [self.audio startRecording];
        sender.tag = 1;
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        
    }else if (sender.tag==1) {
        [self.contentView removeAllSubviewOfClass:[UIButton class]];
        [self.audio stopRecording];
        [self.audio copyRecordedAudioFileToURL:fileURL];
        [self performSelectorInBackground:@selector(prepareForNewRecording) withObject:nil];
        sender.tag = 2;
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }else if (sender.tag==2) {
        [self.audio preparePlayingWithContents:fileURL
                                      callback:nil
                                        finish:nil];
        [self.audio startPlayingWithCurrentTime:0];
        sender.tag = 0;
        [sender setTitle:@"录音" forState:UIControlStateNormal];
    }
}

@end
