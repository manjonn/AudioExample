//
//  ViewController.m
//  AudioExample
//
//  Created by Manjula Jonnalagadda on 7/22/15.
//  Copyright (c) 2015 Manjula Jonnalagadda. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController (){
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
}
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"song.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    settings[AVFormatIDKey]=@(kAudioFormatMPEG4AAC);
    settings[AVSampleRateKey]=@44100.0;
    settings[AVNumberOfChannelsKey]=@2;
    
    
     _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:settings error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)play:(UIButton *)sender {
    
    if (!_recorder.recording){
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
        [_player play];
    }
}
- (IBAction)record:(UIButton *)sender {
    
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [_recorder record];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [_recorder pause];
        [sender setTitle:@"Record" forState:UIControlStateNormal];
    }
    self.playButton.enabled=NO;
    self.stopButton.enabled=YES;
}
- (IBAction)stop:(UIButton *)sender {
    
    [_recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    self.playButton.enabled=YES;
    self.stopButton.enabled=NO;

}

@end
