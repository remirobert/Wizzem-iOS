//
//  PhotoViewController.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <FLAnimatedImage.h>
#import "PhotoViewController.h"
#import "CameraAVFoundation.h"
#import "ActionCameraAVFoundation.h"
#import "ActionGifCameraAVFoundation.h"
#import "FileManager.h"
#import "SliderButtonPhoto.h"
#import "DetailCameraViewController.h"

@interface PhotoViewController ()
@property (nonatomic, strong) UIScrollView *photoLib;
@property (nonatomic, assign) NSInteger clic;
@end

@implementation PhotoViewController

- (void) takePhoto {
    self.clic += 1;
    
    if (self.clic == 3) {
        if ([ActionGifCameraAVFoundation sharedInstance].isWorking) {
            return;
        }
        
        [ActionGifCameraAVFoundation makeAnimatedGif:^(NSURL *fileUrl) {
            [ActionGifCameraAVFoundation releaseImages];
            
            NSData *gifData = [FileManager getDataFromFile:@"animated.gif"];
            
            FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
            FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
            imageView.animatedImage = image;
            imageView.frame = self.view.frame;
            [self.view addSubview:imageView];
            
            [FileManager deleteFile:@"animated.gif"];
            
            self.clic = 0;
        }];
        return;
    }
    
    //tatic NSInteger position = 0;

    [ActionGifCameraAVFoundation addImage];
    
//    [ActionCameraAVFoundation takePhoto:^(UIImage *image) {
//        
//        UIImageView *currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(position, 0, 70, 70)];
//        currentImage.image = image;
//        [self.photoLib addSubview:currentImage];
//        position += 70;
//        
//        self.photoLib.contentSize = CGSizeMake(position, 70);
//    }];
}

- (void) changeActionCamera:(CAMERA_KIND)cameraKind {
    static UILabel *label;
    
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:50];
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
    switch (cameraKind) {
        case PHOTO_CAMERA:
            label.text = @"Photo";
            break;

        case GIF_CAMERA:
            label.text = @"GIF";
            break;

        default:
            break;
    }
    
    label.frame = CGRectMake(0, -100, self.view.frame.size.width, 100);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionTransitionNone animations:^{
        
        label.alpha = 1.0;
        label.frame = CGRectMake(0, 50, self.view.frame.size.width, 100);
        
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.5 animations:^{
           label.alpha = 0.0;
       }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clic = 0;
    
    [self.view.layer addSublayer:[CameraAVFoundation sharedInstace].captureVideoPreviewLayer];

//    UIButton *button = [[UIButton alloc] init];
//    button.frame = CGRectMake(0, 0, 100, 100);
//    button.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 120);
//    
//    button.layer.cornerRadius = 50;
//    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
//    
//    [button addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:button];
//    

    SliderButtonPhoto *slider = [[SliderButtonPhoto alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height - 120, 100, 100)];
    slider.delegateCamera = self;
    [self.view addSubview:slider];
    
    
    self.photoLib = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    self.photoLib.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.photoLib];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
