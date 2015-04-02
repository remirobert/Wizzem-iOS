//
//  GifCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "GifCaptureViewController.h"
#import <PBJVision/PBJGLProgram.h>
#import <PBJGLProgram.h>
#import <PBJVision.h>
#import "PBJStrobeView.h"
#import <PBJVision/PBJVision.h>
#import "MakeAnimatedImage.h"

@interface GifCaptureViewController () <PBJVisionDelegate>
@property (nonatomic, strong) PBJStrobeView *cameraPreview;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) IBOutlet UIButton *generateButton;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation GifCaptureViewController

#pragma mark -
#pragma mark PBJVisionDelegate

- (IBAction)generateGif:(id)sender {
    [MakeAnimatedImage makeAnimatedGif:self.photos blockCompletion:^(NSData *gif) {
        self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaGif genericObjectMedia:gif];
        [self displayMedia];
    }];
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error {
    UIImage *img = [photoDict objectForKey:PBJVisionPhotoImageKey];
    [self.photos addObject:img];
    [[PBJVision sharedInstance] startPreview];
}


- (IBAction)takePhoto:(id)sender {
    [[PBJVision sharedInstance] capturePhoto];
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [[NSMutableArray alloc] init];
    
    [PBJVision sharedInstance].delegate = self;
    [PBJVision sharedInstance].cameraMode = PBJCameraModePhoto;
    [PBJVision sharedInstance].outputFormat = PBJOutputFormatSquare;
    
    self.previewView = [[UIView alloc] initWithFrame:CGRectZero];
    self.previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 60.0f, 200, 200);
    self.previewView.frame = previewFrame;
    self.previewLayer = [[PBJVision sharedInstance] previewLayer];
    self.previewLayer.frame = self.previewView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.previewView];
}

@end
