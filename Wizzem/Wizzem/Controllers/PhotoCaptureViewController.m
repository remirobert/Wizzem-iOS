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

@interface PhotoCaptureViewController () <PBJVisionDelegate>
@property (nonatomic, strong) PBJStrobeView *cameraPreview;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) IBOutlet UIButton *crossButton;
@end

@implementation PhotoCaptureViewController

#pragma mark -
#pragma mark PBJVisionDelegate

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error {
    UIImage *img = [photoDict objectForKey:PBJVisionPhotoImageKey];
    NSLog(@"img %@", img);
    [self displayPhoto:img];
}

#pragma mark -
#pragma mark - IBaction

- (IBAction)dismissController:(id)sender {
}

- (void)takeCapture {
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

- (void)viewDidLayoutSubviews {
    [self.crossButton setImage:[[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.crossButton.tintColor = [UIColor colorWithRed:0.41 green:0.4 blue:0.52 alpha:1];
    self.crossButton.frame = CGRectMake(10, 10, 40, 40);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.2 alpha:1];
    
    [PBJVision sharedInstance].delegate = self;
    [PBJVision sharedInstance].cameraMode = PBJCameraModePhoto;
    [PBJVision sharedInstance].outputFormat = PBJOutputFormatSquare;
    
    self.previewView = [[UIView alloc] initWithFrame:CGRectZero];
    self.previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 60.0f, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    self.previewView.frame = previewFrame;
    self.previewLayer = [[PBJVision sharedInstance] previewLayer];
    self.previewLayer.frame = self.previewView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.previewView];
    
    
    UIButton *click = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 50, 50)];
    [click addTarget:self action:@selector(takeCapture) forControlEvents:UIControlEventTouchUpInside];
    click.backgroundColor = [UIColor blackColor];
    [self.view addSubview:click];
}

@end
