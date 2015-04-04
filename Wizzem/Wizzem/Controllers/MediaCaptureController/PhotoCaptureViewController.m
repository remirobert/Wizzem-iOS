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
#import <PBJVision/PBJVision.h>
#import "PBJStrobeView.h"
#import "PreviewLayerMediaCaptureView.h"
#import "DismissButton.h"

@interface PhotoCaptureViewController () <PBJVisionDelegate>
@property (nonatomic, strong) PreviewLayerMediaCaptureView *previewCamera;
@property (nonatomic, strong) DismissButton *crossButton;
@end

@implementation PhotoCaptureViewController

#pragma mark -
#pragma mark PBJVisionDelegate

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error {
    UIImage *img = [photoDict objectForKey:PBJVisionPhotoImageKey];
    self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaPhoto genericObjectMedia:img];
    [self displayMedia];
}

#pragma mark -
#pragma mark - IBaction

- (IBAction)takePhoto:(id)sender {
    [[PBJVision sharedInstance] capturePhoto];
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
    
    [PBJVision sharedInstance].delegate = self;
    [PBJVision sharedInstance].cameraMode = PBJCameraModePhoto;
    [PBJVision sharedInstance].outputFormat = PBJOutputFormatSquare;

    self.previewCamera = [PreviewLayerMediaCaptureView preview];
    
    CGRect previewFrame = CGRectMake(0, 60.0f, 200, 200);
    self.previewCamera.frame = previewFrame;
    [self.view addSubview:self.previewCamera];
    
    self.crossButton = [[DismissButton alloc] initWithFrame:CGRectMake(10, 300, 40, 40)];
    [self.crossButton addTarget:self action:@selector(dismissMediaController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crossButton];
}

@end
