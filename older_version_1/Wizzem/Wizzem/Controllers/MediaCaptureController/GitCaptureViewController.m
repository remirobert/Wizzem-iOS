//
//  GitCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 19/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "GitCaptureViewController.h"
#import "MakeAnimatedImage.h"
#import "ColorPicker.h"
#import "ShimmerView.h"
#import "ProgressBar.h"

@interface GitCaptureViewController ()
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, assign) BOOL isTaken;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *captureButton;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) ProgressBar *progressBar;
@end

@implementation GitCaptureViewController

- (void)endGifCapture {
    [MakeAnimatedImage makeAnimatedGif:self.photos speedGifFrame:GIF_SPEED_NORMAL blockCompletion:^(NSData *gif) {
        NSDictionary *gifContent = @{@"photos":self.photos, @"data":gif};
        
        self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaGif genericObjectMedia:gifContent];
        [self displayMedia];
    }];
}

- (void)takePicture {
    if (self.photos.count == 1) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.captureButton.center = CGPointMake(self.view.frame.size.width - 50, self.recordingButton.center.y);
        } completion:nil];
    }
    if (self.photos.count == 10) {
        [self endGifCapture];
    }
    if (self.isTaken) {
        return;
    }
    [self.progressBar setProgress:self.progressBar.currentValue + 1];
    self.isTaken = true;
    [WizzMedia capturePhoto:^(UIImage *image) {
        self.isTaken = false;
        [self.photos addObject:image];
    }];
}

- (void)changeRotationCamera {
    [WizzMedia switchDeviceCamera];
}

- (UIButton *)captureButton {
    if (!_captureButton) {
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captureButton.frame = CGRectMake(0, 0, 50, 50);
        [_captureButton setImage:[[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _captureButton.tintColor = [UIColor colorWithRed:0.25 green:0.24 blue:0.3 alpha:1];
        [_captureButton addTarget:self action:@selector(endGifCapture) forControlEvents:UIControlEventTouchUpInside];
        _captureButton.center = CGPointMake(self.view.frame.size.width + 25, self.recordingButton.center.y);
    }
    return _captureButton;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (ProgressBar *)progressBar {
    if (!_progressBar) {
        _progressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 4)];
        _progressBar.backgroundColor = [UIColor whiteColor];
        _progressBar.maxValue = 10;
        _progressBar.currentValue = 0;
        
        [_progressBar backgroundColor:[UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1]];
        [_progressBar progressColor:[UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1]];
        [_progressBar setCurrentValue:0];
    }
    return _progressBar;
}

- (void)viewDidDisappear:(BOOL)animated {
    [WizzMedia stopSession];
}

- (void)viewDidAppear:(BOOL)animated {
    [WizzMedia startSession];
    [self.progressBar setProgress:0];
    self.captureButton.center = CGPointMake(self.view.frame.size.width + 25, self.recordingButton.center.y);
    [self.photos removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    UIView *preview = [WizzMedia previewCamera:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)];
    preview.frame = CGRectMake(0, 64, preview.frame.size.width, preview.frame.size.width);
    [self.view addSubview:preview];

    ShimmerView *shimmeringView = [[ShimmerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 69, self.view.frame.size.width, 20)];
    shimmeringView.text = @"Tap to add a picture";
    shimmeringView.textColor = [UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1];
    [self.view addSubview:shimmeringView];
    
    
    UIButton *buttonRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRecord.backgroundColor = [UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1];
    
    buttonRecord.frame = CGRectMake(self.view.frame.size.width / 2 - self.view.frame.size.width / 3 / 2,
                                    self.view.frame.size.width + 64 + ((self.view.frame.size.height - self.view.frame.size.width - 64) / 2 - self.view.frame.size.width / 3 / 2),
                                    self.view.frame.size.width / 3,
                                    self.view.frame.size.width / 3);
    buttonRecord.layer.cornerRadius = buttonRecord.frame.size.width / 2;
    [buttonRecord addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonRecord];
    
    self.recordingButton = buttonRecord;
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flashButton setImage:[[UIImage imageNamed:@"flash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.flashButton.frame = CGRectMake(10, 0, 40, 40);
    self.flashButton.center = CGPointMake(35, self.view.frame.size.width + 64 - 20);
    self.flashButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    //[self.flashButton addTarget:self action:@selector(changeFlashMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationButton setImage:[[UIImage imageNamed:@"rotation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    rotationButton.frame = CGRectMake(10, 0, 40, 40);
    rotationButton.center = CGPointMake(self.view.frame.size.width - 10 - 25, self.view.frame.size.width + 64 - 20);
    rotationButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [rotationButton addTarget:self action:@selector(changeRotationCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationButton];
    
    [self.view addSubview:self.captureButton];
    [self.view addSubview:self.progressBar];
}

@end
