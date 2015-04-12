//
//  VideoCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 02/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MovieCaptureViewController.h"
#import <PBJVision/PBJGLProgram.h>
#import <PBJGLProgram.h>
#import <PBJVision.h>
#import "PBJStrobeView.h"
#import <PBJVision/PBJVision.h>
#import "PreviewLayerMediaCaptureView.h"
#import "MakeAnimatedImage.h"
#import "DismissButton.h"
#import "ShimmerView.h"
#import "Colors.h"

@interface MovieCaptureViewController () <PBJVisionDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) PreviewLayerMediaCaptureView *previewCamera;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) ShimmerView *shimmerLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *captureButton;
@end

@implementation MovieCaptureViewController

#pragma mark -
#pragma mark capture delegate

- (void)vision:(PBJVision *)vision didCaptureAudioSample:(CMSampleBufferRef)sampleBuffer {
    NSLog(@"capture : %f", [PBJVision sharedInstance].capturedVideoSeconds);
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f", [PBJVision sharedInstance].capturedVideoSeconds];
    
    if ([PBJVision sharedInstance].capturedVideoSeconds >= 2.5) {
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            self.captureButton.alpha = 1;
        } completion:nil];
    }
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error {
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"recording session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    NSString *videoPath = [videoDict  objectForKey:PBJVisionVideoPathKey];
    self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaVideo genericObjectMedia:videoPath];
    [self displayMedia];
}

#pragma mark -
#pragma mark capture management

- (void)startRecording {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.isRecording = true;
    [[PBJVision sharedInstance] startVideoCapture];
    self.shimmerLabel.text = @"Recording ...";
}

- (void)pauseRecording {
    if (self.isRecording) {
        [[PBJVision sharedInstance] pauseVideoCapture];
    }
    self.shimmerLabel.text = @"Press to record";
}

- (void)resumeRecording {
    if (self.isRecording) {
        [[PBJVision sharedInstance] resumeVideoCapture];
    }
    self.shimmerLabel.text = @"Recording ...";
}

- (IBAction)endRecording:(id)sender {
    NSLog(@"end recording");
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.isRecording = false;
    [[PBJVision sharedInstance] endVideoCapture];
}

- (void)changeRotationCamera {
    if ([PBJVision sharedInstance].cameraDevice == PBJCameraDeviceFront) {
        [[PBJVision sharedInstance] setCameraDevice:PBJCameraDeviceBack];
    }
    else {
        [[PBJVision sharedInstance] setCameraDevice:PBJCameraDeviceFront];
    }
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

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + self.view.frame.size.width + 10, self.view.frame.size.width, 20)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:15];
        _timeLabel.text = @"";
    }
    return _timeLabel;
}

- (UIButton *)captureButton {
    if (!_captureButton) {
        _captureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 10, 40, 40)];
        _captureButton.backgroundColor = [UIColor grayColor];
        _captureButton.alpha = 0;
        [_captureButton addTarget:self action:@selector(endRecording:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureButton;
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[PBJVision sharedInstance] startPreview];
    self.timeLabel.text = @"";
    self.captureButton.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PBJVision sharedInstance] stopPreview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRecording = false;
    
    [PBJVision sharedInstance].delegate = self;
    [PBJVision sharedInstance].cameraMode = PBJCameraModeVideo;
    [PBJVision sharedInstance].outputFormat = PBJOutputFormatSquare;
    [PBJVision sharedInstance].cameraOrientation = PBJCameraOrientationPortrait;
    
    
    [[PBJVision sharedInstance] setMaximumCaptureDuration:CMTimeMakeWithSeconds(15, 600)];
    
    self.previewCamera = [PreviewLayerMediaCaptureView preview];
    
    self.previewCamera.frame = CGRectMake(0, 64, 10, 10);
    [self.view addSubview:self.previewCamera];
    
    
    [self.view addSubview:self.captureButton];
    
    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rotationButton.frame = CGRectMake(self.view.frame.size.width - 50, 64 + self.view.frame.size.width - 50, 40, 40);
    [rotationButton setImage:[UIImage imageNamed:@"rotation"] forState:UIControlStateNormal];
    [rotationButton addTarget:self action:@selector(changeRotationCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationButton];

    [self.view addSubview:self.timeLabel];
    
    [self.view addSubview:self.shimmerLabel];
    [self.shimmerLabel addGestureRecognizer:self.longPressGestureRecognizer];
}

@end
