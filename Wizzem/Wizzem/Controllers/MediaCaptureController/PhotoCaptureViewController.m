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

@interface PhotoCaptureViewController () <FastttCameraDelegate>
@property (nonatomic, strong) PreviewLayerMediaCaptureView *previewCamera;
@property (nonatomic, strong) DismissButton *crossButton;
@property (nonatomic, strong) FastttCamera *fastCamera;
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

- (IBAction)takePhoto:(id)sender {
    [self.fastCamera takePicture];
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = CGRectMake(0, 60.0f, self.view.frame.size.width, self.view.frame.size.width);
    
    
//    [PBJVision sharedInstance].delegate = self;
//    [PBJVision sharedInstance].cameraMode = PBJCameraModePhoto;
//    
//
//    self.previewCamera = [PreviewLayerMediaCaptureView preview];
//    
//    CGRect previewFrame = CGRectMake(0, 60.0f, 200, 200);
//    self.previewCamera.frame = previewFrame;
//    [self.view addSubview:self.previewCamera];
    
    self.crossButton = [[DismissButton alloc] initWithFrame:CGRectMake(10, 300, 40, 40)];
    [self.crossButton addTarget:self action:@selector(dismissMediaController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crossButton];
}

@end
