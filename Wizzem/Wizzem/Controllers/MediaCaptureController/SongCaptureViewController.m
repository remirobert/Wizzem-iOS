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

@interface SongCaptureViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewRecord;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) DismissButton *crossButton;
@property (nonatomic, strong) ShimmerView *shimmerLabel;
@property (nonatomic, strong) UIImageView *recordImage;
@property (nonatomic, strong) MultiplePulsingHaloLayer *mutiHal;
@end

@implementation SongCaptureViewController

- (void)startRecording {
    self.isRecording = true;
    NSLog(@"start recording");
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
    self.mutiHal.radius = 0;
    self.shimmerLabel.text = @"Press to record";
    if (self.isRecording) {
        [WizzMedia pauseRecordSong];
    }
}

- (void)resumeRecording {
    NSLog(@"resume recording");
    self.mutiHal.radius = self.view.frame.size.width / 2;
    self.shimmerLabel.text = @"Recording...";
    if (self.isRecording) {
        [WizzMedia resumeRecordSong];
    }
}

- (IBAction)stopRecording:(id)sender {
    NSLog(@"stop recording");
    self.mutiHal.radius = 0;
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
        _shimmerLabel.textColor = [Colors greenColor];
    }
    return _shimmerLabel;
}

- (UIImageView *)recordImage {
    if (!_recordImage) {
        _recordImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
        _recordImage.image = [[UIImage imageNamed:@"record"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _recordImage.tintColor = [UIColor grayColor];
        _recordImage.backgroundColor = [UIColor clearColor];
        _recordImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _recordImage;
}

- (MultiplePulsingHaloLayer *)mutiHal {
    if (!_mutiHal) {
        _mutiHal = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:1];
        _mutiHal.position = self.recordImage.center;
        _mutiHal.useTimingFunction = NO;
        [_mutiHal buildSublayers];
        _mutiHal.radius = 0;
        //_mutiHal.backgroundColor = [UIColor grayColor].CGColor;
        [_mutiHal setHaloLayerColor:[Colors greenColor].CGColor];
        
    }
    return _mutiHal;
}

#pragma mark -
#pragma UIView cycle

- (void)viewDidAppear:(BOOL)animated {
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.shimmerLabel];
    [self.shimmerLabel addGestureRecognizer:self.longPressGestureRecognizer];
    
    [self.view addSubview:self.recordImage];
    [self.view.layer insertSublayer:self.mutiHal below:self.recordImage.layer];
}

@end
