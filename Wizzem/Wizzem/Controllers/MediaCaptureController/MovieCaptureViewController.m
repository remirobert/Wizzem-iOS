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

@interface MovieCaptureViewController () <PBJVisionDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) PreviewLayerMediaCaptureView *previewCamera;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIButton *generateButton;
@property (nonatomic, strong) NSMutableArray *photos;
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
}

- (void)pauseRecording {
    if (self.isRecording) {
        [[PBJVision sharedInstance] pauseVideoCapture];
    }
}

- (void)resumeRecording {
    if (self.isRecording) {
        [[PBJVision sharedInstance] resumeVideoCapture];
    }
}

- (IBAction)endRecording:(id)sender {
    NSLog(@"end recording");
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.isRecording = false;
    [[PBJVision sharedInstance] endVideoCapture];
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
    
    self.previewCamera = [PreviewLayerMediaCaptureView preview];
    
    CGRect previewFrame = CGRectMake(0, 60.0f, 200, 200);
    self.previewCamera.frame = previewFrame;
    [self.view addSubview:self.previewCamera];
    
    [self.previewCamera addGestureRecognizer:self.longPressGestureRecognizer];
}

@end
