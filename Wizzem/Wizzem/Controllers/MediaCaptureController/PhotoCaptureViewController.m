//
//  PhotoCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 30/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "PhotoCaptureViewController.h"
#import <PBJVision/PBJGLProgram.h>
#import <PBJGLProgram.h>
#import <PBJVision.h>
#import "PBJStrobeView.h"
#import "PreviewLayerMediaCaptureView.h"
#import "DismissButton.h"
#import <FastttCamera/FastttCamera.h>
#import <FBShimmeringView.h>
#import <FBShimmering.h>
#import <SCRecorder/SCRecorder.h>
#import "Colors.h"
#import "ShimmerView.h"
#import "MenuMediaViewController.h"

@interface PhotoCaptureViewController () <FastttCameraDelegate, SCRecorderDelegate>
@property (nonatomic, strong) PreviewLayerMediaCaptureView *previewCamera;
@property (nonatomic, strong) DismissButton *crossButton;
@property (nonatomic, strong) FastttCamera *fastCamera;
@property (nonatomic, strong) SCRecorder *recorder;
@property (nonatomic, strong) SCRecordSession *recordSession;
@end

@implementation PhotoCaptureViewController

#pragma mark -
#pragma mark FAsstCamera

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage {
    self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaPhoto genericObjectMedia:capturedImage.fullImage];
    [self displayMedia];
}

#pragma mark -
#pragma mark - IBaction

- (IBAction)takePhoto {
    [self.fastCamera takePicture];
}

- (void)changeRotationCamera {
    if (self.fastCamera.cameraDevice == FastttCameraDeviceRear) {
        if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceFront]) {
            [self.fastCamera setCameraDevice:FastttCameraDeviceFront];
        }
    }
    else {
        if ([FastttCamera isCameraDeviceAvailable:FastttCameraDeviceRear]) {
            [self.fastCamera setCameraDevice:FastttCameraDeviceRear];
        }
    }
}

- (void)selectMedia {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuMediaViewController *menuController;
    if (mainStoryboard && (menuController = [mainStoryboard instantiateViewControllerWithIdentifier:@"menuController"])) {
        menuController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [self presentViewController:menuController animated:true completion:nil];
    }
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width);

    
    
//    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rotationButton.frame = CGRectMake(self.view.frame.size.width - 50, 64 + self.view.frame.size.width - 50, 40, 40);
//    [rotationButton setImage:[UIImage imageNamed:@"rotation"] forState:UIControlStateNormal];
//    [rotationButton addTarget:self action:@selector(changeRotationCamera) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rotationButton];
    
    ShimmerView *shimmeringView = [[ShimmerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 64, self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.width + 64))];
    shimmeringView.text = @"Tap to take a picture";
    shimmeringView.textColor = [Colors greenColor];
    [self.view addSubview:shimmeringView];
    
    
//    UIButton *buttonRecord = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonRecord setImage:[[UIImage imageNamed:@"photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    buttonRecord.backgroundColor = [UIColor clearColor];
//    
//    buttonRecord.frame = CGRectMake(0, self.view.frame.size.width + 64, 200, 200);
//    buttonRecord.layer.cornerRadius = buttonRecord.frame.size.width / 2;
//    buttonRecord.layer.borderWidth = 5;
//    buttonRecord.layer.borderColor = [UIColor grayColor].CGColor;
//    buttonRecord.tintColor = [UIColor grayColor];
//    
//    [self.view addSubview:buttonRecord];
    
//    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 64, self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.width + 64))];
//    [self.view addSubview:shimmeringView];
//    
//    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
//    loadingLabel.textAlignment = NSTextAlignmentCenter;
//    loadingLabel.textColor = [Colors greenColor];
//    loadingLabel.font = [UIFont boldSystemFontOfSize:20];
//    loadingLabel.text = @"Tap to take a picture";
//    shimmeringView.contentView = loadingLabel;
//    shimmeringView.shimmeringAnimationOpacity = 0.1;
//    shimmeringView.shimmeringSpeed = 300;
//    shimmeringView.shimmering = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    tapGesture.numberOfTapsRequired = 1;
    [shimmeringView addGestureRecognizer:tapGesture];
    
    
//    UIButton *mediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    mediaButton.frame = CGRectMake(self.view.frame.size.width / 2 - 15, self.view.frame.size.height - 40, 30, 30);
//    mediaButton.backgroundColor = [UIColor redColor];
//    [mediaButton addTarget:self action:@selector(selectMedia) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:mediaButton];

//    self.crossButton = [[DismissButton alloc] initWithFrame:CGRectMake(10, 300, 40, 40)];
//    [self.crossButton addTarget:self action:@selector(dismissMediaController) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.crossButton];    
}

@end
