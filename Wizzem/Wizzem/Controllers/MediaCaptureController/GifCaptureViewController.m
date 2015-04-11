//
//  GifCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "GifCaptureViewController.h"
#import <PBJVision/PBJGLProgram.h>
#import <FastttCamera.h>
#import <PBJGLProgram.h>
#import "PBJStrobeView.h"
#import "PreviewLayerMediaCaptureView.h"
#import "MakeAnimatedImage.h"
#import "DismissButton.h"
#import "Wizzem-Swift.h"

@interface GifCaptureViewController () <FastttCameraDelegate>
@property (nonatomic, strong) PreviewLayerMediaCaptureView *previewCamera;
@property (strong, nonatomic) IBOutlet UIButton *generateButton;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) DismissButton *crossButton;
@property (nonatomic, strong) FastttCamera *fastCamera;
@end

@implementation GifCaptureViewController

#pragma mark -
#pragma mark PBJVisionDelegate

- (IBAction)generateGif:(id)sender {
    [MakeAnimatedImage saveGIFToPhotoAlbumFromImages:self.photos WithCallbackBlock:^{
        NSLog(@"gif saved;");
    }];
//    [MakeAnimatedImage makeAnimatedGif:self.photos blockCompletion:^(NSData *gif) {
//        self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaGif genericObjectMedia:gif];
//        [self displayMedia];
//    }];
}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage {
    [self.photos addObject:capturedImage.fullImage];
}

- (IBAction)takePhoto:(id)sender {
    [self.fastCamera takePicture];
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [[NSMutableArray alloc] init];
    
    self.fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = CGRectMake(0, 60.0f, self.view.frame.size.width, self.view.frame.size.width);
    
    
//    [PBJVision sharedInstance].delegate = self;
//    [PBJVision sharedInstance].cameraMode = PBJCameraModePhoto;
//    [PBJVision sharedInstance].outputFormat = PBJOutputFormatSquare;
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
