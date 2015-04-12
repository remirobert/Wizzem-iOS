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
@end

@implementation MovieCaptureViewController

#pragma mark -
#pragma mark capture delegate

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

#pragma mark -
#pragma mark UIView cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[PBJVision sharedInstance] startPreview];
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
    
    
    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rotationButton.frame = CGRectMake(self.view.frame.size.width - 50, 64 + self.view.frame.size.width - 50, 40, 40);
    [rotationButton setImage:[UIImage imageNamed:@"rotation"] forState:UIControlStateNormal];
    [rotationButton addTarget:self action:@selector(changeRotationCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationButton];

    
    [self.view addSubview:self.shimmerLabel];
    [self.shimmerLabel addGestureRecognizer:self.longPressGestureRecognizer];
}

@end
