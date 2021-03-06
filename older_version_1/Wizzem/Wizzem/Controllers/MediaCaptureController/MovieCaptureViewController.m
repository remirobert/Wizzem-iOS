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
#import "ProgressBar.h"

@interface MovieCaptureViewController () <PBJVisionDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) PreviewLayerMediaCaptureView *previewCamera;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) ShimmerView *shimmerLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *captureButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) ProgressBar *progressBar;
@end

@implementation MovieCaptureViewController

#pragma mark -
#pragma mark capture delegate

- (void)vision:(PBJVision *)vision didCaptureAudioSample:(CMSampleBufferRef)sampleBuffer {
    NSLog(@"capture : %f", [PBJVision sharedInstance].capturedVideoSeconds);
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f", [PBJVision sharedInstance].capturedVideoSeconds];
    
    [self.progressBar setProgress:[PBJVision sharedInstance].capturedVideoSeconds];
    
    if ([PBJVision sharedInstance].capturedVideoSeconds >= 3) {
        
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.captureButton.center = CGPointMake(self.view.frame.size.width - 50, self.recordingButton.center.y);
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

- (void)changeFlashMode {
    if ([PBJVision sharedInstance].flashMode == PBJFlashModeOff) {
        [[PBJVision sharedInstance] setFlashMode:PBJFlashModeOn];
        self.flashButton.tintColor = [UIColor yellowColor];
    }
    else {
        [[PBJVision sharedInstance] setFlashMode:PBJFlashModeOff];
        self.flashButton.tintColor = [UIColor colorWithRed:0.25 green:0.24 blue:0.3 alpha:1];
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
        _shimmerLabel = [[ShimmerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 69, self.view.frame.size.width, 20)];
        _shimmerLabel.text = @"Press to record";
        _shimmerLabel.textColor = [UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:1];
    }
    return _shimmerLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 10, self.view.frame.size.width, 20)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _timeLabel.font = [UIFont boldSystemFontOfSize:20];
        _timeLabel.text = @"";
    }
    return _timeLabel;
}

- (UIButton *)captureButton {
    if (!_captureButton) {
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captureButton.frame = CGRectMake(0, 0, 50, 50);
        [_captureButton setImage:[[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _captureButton.tintColor = [UIColor colorWithRed:0.25 green:0.24 blue:0.3 alpha:1];
        [_captureButton addTarget:self action:@selector(endRecording:) forControlEvents:UIControlEventTouchUpInside];
        _captureButton.center = CGPointMake(self.view.frame.size.width + 25, self.recordingButton.center.y);
    }
    return _captureButton;
}

- (ProgressBar *)progressBar {
    if (!_progressBar) {
        _progressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 4)];
        _progressBar.backgroundColor = [UIColor whiteColor];
        _progressBar.maxValue = 10;
        _progressBar.currentValue = 0;
        
        [_progressBar backgroundColor:[UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1]];
        [_progressBar progressColor:[UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:1]];
        [_progressBar setCurrentValue:0];
    }
    return _progressBar;
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[PBJVision sharedInstance] startPreview];
    self.timeLabel.text = @"";
    [self.progressBar setProgress:0];
    self.captureButton.center = CGPointMake(self.view.frame.size.width + 25, self.recordingButton.center.y);
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
    
    NSLog(@"path : %@", [PBJVision sharedInstance].captureDirectory);
    
    [[PBJVision sharedInstance] setMaximumCaptureDuration:CMTimeMakeWithSeconds(15, 600)];
    
    self.previewCamera = [PreviewLayerMediaCaptureView preview];
    
    self.previewCamera.frame = CGRectMake(0, 64, 10, 10);
    [self.view addSubview:self.previewCamera];
    
    
//    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rotationButton.frame = CGRectMake(self.view.frame.size.width - 50, 64 + self.view.frame.size.width - 50, 40, 40);
//    [rotationButton setImage:[UIImage imageNamed:@"rotation"] forState:UIControlStateNormal];
//    [rotationButton addTarget:self action:@selector(changeRotationCamera) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rotationButton];
//
//    [self.view addSubview:self.timeLabel];
//    
    [self.view addSubview:self.shimmerLabel];
//    [self.shimmerLabel addGestureRecognizer:self.longPressGestureRecognizer];
    
    
    
    UIButton *buttonRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRecord.backgroundColor = [UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:1];
    
    buttonRecord.frame = CGRectMake(self.view.frame.size.width / 2 - self.view.frame.size.width / 3 / 2,
                                    self.view.frame.size.width + 64 + ((self.view.frame.size.height - self.view.frame.size.width - 64) / 2 - self.view.frame.size.width / 3 / 2),
                                    self.view.frame.size.width / 3,
                                    self.view.frame.size.width / 3);
    buttonRecord.layer.cornerRadius = buttonRecord.frame.size.width / 2;
    
    [self.view addSubview:buttonRecord];
    
    
    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationButton setImage:[[UIImage imageNamed:@"rotation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    rotationButton.frame = CGRectMake(10, 0, 40, 40);
    rotationButton.center = CGPointMake(self.view.frame.size.width - 10 - 25, self.view.frame.size.width + 64 - 20);
    rotationButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [rotationButton addTarget:self action:@selector(changeRotationCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationButton];
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flashButton setImage:[[UIImage imageNamed:@"flash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.flashButton.frame = CGRectMake(10, 0, 40, 40);
    self.flashButton.center = CGPointMake(35, self.view.frame.size.width + 64 - 20);
    self.flashButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.flashButton addTarget:self action:@selector(changeFlashMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    [buttonRecord addGestureRecognizer:self.longPressGestureRecognizer];
    
    self.recordingButton = buttonRecord;
    [self.view addSubview:self.captureButton];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.progressBar];
}

@end
