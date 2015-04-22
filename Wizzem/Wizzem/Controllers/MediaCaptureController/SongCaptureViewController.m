//
//  SongCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 02/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SongCaptureViewController.h"
#import "WizzMedia.h"
#import "DismissButton.h"
#import "ShimmerView.h"
#import "Colors.h"
#import "MultiplePulsingHaloLayer.h"
#import "ProgressBar.h"

@interface SongCaptureViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewRecord;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) DismissButton *crossButton;
@property (nonatomic, strong) ShimmerView *shimmerLabel;
@property (nonatomic, strong) MultiplePulsingHaloLayer *mutiHal;
@property (nonatomic, strong) UILabel *currentTimeRecorded;
@property (nonatomic, strong) UIButton *validateButton;
@property (nonatomic, strong) UIButton *buttonRecord;
@property (nonatomic, strong) ProgressBar *progressBar;
@end

@implementation SongCaptureViewController

- (void)startRecording {
    self.isRecording = true;
    NSLog(@"start recording");
    
    NSLog(@"hal : %@ %f %f", self.mutiHal, self.mutiHal.frame.size.width, self.mutiHal.frame.size.height);
    
//    [UIView animateWithDuration:0.5 animations:^{
        [_mutiHal setHaloLayerColor:[UIColor grayColor].CGColor];
//    }];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:2 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.buttonRecord.frame = CGRectMake(0, 0, self.view.frame.size.width / 3 + 10, self.view.frame.size.width / 3 + 10);
        self.buttonRecord.layer.cornerRadius = (self.view.frame.size.width / 3 + 10) / 2;
        self.buttonRecord.center = self.view.center;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.5 delay:0.1 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            self.buttonRecord.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, self.view.frame.size.width / 3);
            self.buttonRecord.layer.cornerRadius = (self.view.frame.size.width / 3) / 2;
            self.buttonRecord.center = self.view.center;
        } completion:nil];
    }];
    
    self.mutiHal.radius = self.view.frame.size.width / 2;
    self.shimmerLabel.text = @"Recording...";
    [WizzMedia startRecordSong:^(NSURL *song) {
        NSLog(@"record get song : %@", song);
        self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaSong genericObjectMedia:song];
        [self displayMedia];
    }];
}

- (void)pauseRecording {
    NSLog(@"pause recording");

//    [UIView animateWithDuration:0.5 animations:^{
        [_mutiHal setHaloLayerColor:[UIColor clearColor].CGColor];
//    }];

    self.shimmerLabel.text = @"Press to record";
    if (self.isRecording) {
        [WizzMedia pauseRecordSong];
    }
}

- (void)resumeRecording {
    NSLog(@"resume recording");
//    [UIView animateWithDuration:0.5 animations:^{
        [_mutiHal setHaloLayerColor:[UIColor grayColor].CGColor];
//    }];

    self.shimmerLabel.text = @"Recording...";
    if (self.isRecording) {
        [WizzMedia resumeRecordSong];
    }
}

- (IBAction)stopRecording:(id)sender {
    NSLog(@"stop recording");
    
//    [UIView animateWithDuration:0.5 animations:^{
        [_mutiHal setHaloLayerColor:[UIColor clearColor].CGColor];
//    }];
    
    self.shimmerLabel.text = @"Press to record";
    self.isRecording = false;
    [WizzMedia stopRecordSong];
}

#pragma mark -
#pragma mark handle gesture capture

- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!self.isRecording)
                [self startRecording];
            else
                [self resumeRecording];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self pauseRecording];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark setter getter

- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (!_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        _longPressGestureRecognizer.delegate = self;
        _longPressGestureRecognizer.minimumPressDuration = 0.05f;
        _longPressGestureRecognizer.allowableMovement = 10.0f;
    }
    return _longPressGestureRecognizer;
}

- (ShimmerView *)shimmerLabel {
    if (!_shimmerLabel) {
        _shimmerLabel = [[ShimmerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 64,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height - (self.view.frame.size.width + 64))];
        _shimmerLabel.text = @"Press to record";
        _shimmerLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
        _shimmerLabel.textColor = [UIColor colorWithRed:1 green:0.77 blue:0.01 alpha:1];
    }
    return _shimmerLabel;
}

- (MultiplePulsingHaloLayer *)mutiHal {
    if (!_mutiHal) {
        _mutiHal = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:1];
        _mutiHal.position = self.view.center;
        _mutiHal.useTimingFunction = NO;
        [_mutiHal buildSublayers];
        _mutiHal.radius = self.view.frame.size.width / 2;
        [_mutiHal setHaloLayerColor:[UIColor clearColor].CGColor];
    }
    return _mutiHal;
}

- (UILabel *)currentTimeRecorded {
    if (!_currentTimeRecorded) {
        _currentTimeRecorded = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _currentTimeRecorded.textColor = [UIColor colorWithRed:0.56 green:0.55 blue:0.62 alpha:1];
        _currentTimeRecorded.textAlignment = NSTextAlignmentCenter;
        _currentTimeRecorded.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
        _currentTimeRecorded.font = [UIFont boldSystemFontOfSize:18];
    }
    return _currentTimeRecorded;
}

- (UIButton *)validateButton {
    if (!_validateButton) {
        _validateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_validateButton setImage:[[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _validateButton.tintColor = [UIColor colorWithRed:0.22 green:0.21 blue:0.27 alpha:1];
        [_validateButton addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
        _validateButton.center = CGPointMake(self.view.frame.size.width + 25, self.view.center.y);
    }
    return _validateButton;
}

- (ProgressBar *)progressBar {
    if (!_progressBar) {
        _progressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 4)];
        _progressBar.backgroundColor = [UIColor whiteColor];
        _progressBar.maxValue = 15;
        _progressBar.currentValue = 0;
        
        [_progressBar backgroundColor:[UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1]];
        [_progressBar progressColor:[UIColor colorWithRed:1 green:0.77 blue:0.01 alpha:1]];
        [_progressBar setCurrentValue:0];
    }
    return _progressBar;
}

#pragma mark -
#pragma UIView cycle

- (void)updateTimer {
    self.currentTimeRecorded.text = [NSString stringWithFormat:@"%.0f sec", [WizzMedia currentTime]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressBar setProgress:[WizzMedia currentTime]];
    });
    
    if ([WizzMedia currentTime] >= 3) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.validateButton.center = CGPointMake(self.view.frame.size.width - 50, self.view.center.y);
        } completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view bringSubviewToFront:self.navigationBar];
    [self.view bringSubviewToFront:self.progressBar];
    self.validateButton.center = CGPointMake(self.view.frame.size.width + 25, self.view.center.y);
    [self.progressBar setProgress:0];
    self.mutiHal = nil;
    [self.view.layer insertSublayer:self.mutiHal below:self.buttonRecord.layer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.shimmerLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer) userInfo:nil repeats:true];
    
    [self.view addSubview:self.currentTimeRecorded];
    self.currentTimeRecorded.text = @"0 sec";
    
    [self.view addSubview:self.validateButton];
    
    self.buttonRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonRecord.backgroundColor = [UIColor colorWithRed:1 green:0.77 blue:0.01 alpha:1];
    
    self.buttonRecord.frame = CGRectMake(self.view.frame.size.width / 2 - self.view.frame.size.width / 3 / 2,
                                    self.view.frame.size.width + 64 + ((self.view.frame.size.height - self.view.frame.size.width - 64) / 2 - self.view.frame.size.width / 3 / 2),
                                    self.view.frame.size.width / 3,
                                    self.view.frame.size.width / 3);
    self.buttonRecord.layer.cornerRadius = self.buttonRecord.frame.size.width / 2;
    self.buttonRecord.center = self.view.center;
    [self.view addSubview:self.buttonRecord];
    
    //[self.view.layer insertSublayer:self.mutiHal below:self.buttonRecord.layer];
    
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    [self.buttonRecord addGestureRecognizer:pressGesture];
    
    self.buttonRecord = self.buttonRecord;
    [self.view addSubview:self.progressBar];
}

@end
