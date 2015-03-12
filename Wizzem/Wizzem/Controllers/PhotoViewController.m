//
//  PhotoViewController.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <FLAnimatedImage.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PhotoViewController.h"
#import "CameraAVFoundation.h"
#import "ActionCameraAVFoundation.h"
#import "ActionGifCameraAVFoundation.h"
#import "ActionMovieRecordAVFoundation.h"
#import "FileManager.h"
#import "SliderButtonPhoto.h"
#import "DetailCameraViewController.h"
#import "TakeGifButton.h"

@interface PhotoViewController ()
@property (nonatomic, assign) NSInteger clic;
@property (nonatomic, strong) SliderButtonPhoto *slider;
@property (nonatomic, strong) TakeGifButton *buttonGif;
@end

@implementation PhotoViewController

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    [CameraAVFoundation focusAtPoint:touchPoint];
}

- (void) createVideo {
    [ActionMovieRecordAVFoundation stopMovieRecording:^(NSURL *url) {
        NSLog(@"url : %@", url);

        DetailCameraViewController *controllerDetail = [[DetailCameraViewController alloc] init];
        
        controllerDetail.cameraKind = VIDEO_CAMERA;
        controllerDetail.urlMovie = url;
        [self presentViewController:controllerDetail animated:false completion:nil];
        
    }];
//    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"output" ofType:@"mov"];
//    NSURL*theurl=[NSURL fileURLWithPath:thePath];
//    
//    MPMoviePlayerController *moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:theurl];
//    [moviePlayer.view setFrame:CGRectMake(40, 197, 240, 160)];
//    [moviePlayer prepareToPlay];
//    [moviePlayer setShouldAutoplay:NO]; // And other options you can look through the documentation.
//    [self.view addSubview:moviePlayer.view];
}

- (void) takeVideo {
    if (![ActionMovieRecordAVFoundation isRecording]) {
        [ActionMovieRecordAVFoundation startMovieRecording];
    }
    else {
        [self createVideo];
    }
    //[self performSelector:@selector(createVideo) withObject:nil afterDelay:4];
}

- (void) createGif {
    if ([ActionGifCameraAVFoundation sharedInstance].isWorking) {
        return;
    }
    [ActionGifCameraAVFoundation makeAnimatedGif:^(NSURL *fileUrl) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.slider resetValueCircle];
            [self.buttonGif hideButton];
        });

        [ActionGifCameraAVFoundation releaseImages];
        
        NSData *gifData = [FileManager getDataFromFile:@"animated.gif"];
        [FileManager deleteFile:@"animated.gif"];
        
        self.clic = 0;
        
        DetailCameraViewController *controllerDetail = [[DetailCameraViewController alloc] init];
        
        controllerDetail.cameraKind = GIF_CAMERA;
        controllerDetail.gif = gifData;
        
        [self presentViewController:controllerDetail animated:false completion:nil];
    }];
}

- (void) takeGif {
    if ([ActionGifCameraAVFoundation sharedInstance].isWorking) {
        return;
    }
    self.clic += 1;
    
    if (self.clic == 2) {
        [self.buttonGif displayButton];
    }
    
    if (self.clic == 10) {
        [self.slider incrementValueCircle:10];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self createGif];
        });
        return;
    }
    else {
        [self.slider incrementValueCircle:self.clic];
        [ActionGifCameraAVFoundation addImage];
    }
}

- (void) takePhoto {
    [ActionCameraAVFoundation takePhoto:^(UIImage *image) {
        DetailCameraViewController *controllerDetail = [[DetailCameraViewController alloc] init];
        
        controllerDetail.cameraKind = PHOTO_CAMERA;
        controllerDetail.image = image;
        
        [self presentViewController:controllerDetail animated:false completion:nil];
    }];
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
            [self.slider resetValueCircle];
            [self.buttonGif hideButton];
            [CameraAVFoundation changeFlashMode:AVCaptureTorchModeOn];
            [CameraAVFoundation changeCameraOutputMode:CameraRecordModePhoto];
            break;

        case GIF_CAMERA:
            label.text = @"GIF";
            self.clic = 0;
            [self.slider resetValueCircle];
            [self.buttonGif hideButton];
            [CameraAVFoundation changeCameraOutputMode:CameraRecordModePhoto];
            break;

        case VIDEO_CAMERA:
            label.text = @"Video";
            [self.slider resetValueCircle];
            [self.buttonGif hideButton];
            [CameraAVFoundation changeCameraOutputMode:CameraRecordModeMovie];
            break;
            
        default:
            break;
    }
    
    label.frame = CGRectMake(0, -100, self.view.frame.size.width, 100);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4
                        options:UIViewAnimationOptionTransitionNone animations:^{
        
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
    
    [CameraAVFoundation sharedInstace].captureVideoPreviewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:[CameraAVFoundation sharedInstace].captureVideoPreviewLayer];

    self.slider = [[SliderButtonPhoto alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height - 130, 100, 100)];
    self.slider.delegateCamera = self;
    [self.slider initCircleView:self.view];
    [self.view addSubview:self.slider];
    
    
    for (UIButton *currentButtonPhoto in [self.slider buttonForKind:PHOTO_CAMERA]) {
        [currentButtonPhoto addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton *currentButtonGif in [self.slider buttonForKind:GIF_CAMERA]) {
        [currentButtonGif addTarget:self action:@selector(takeGif) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton *currentButtonGif in [self.slider buttonForKind:VIDEO_CAMERA]) {
        [currentButtonGif addTarget:self action:@selector(takeVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.buttonGif = [[TakeGifButton alloc] init];
    [self.buttonGif addTarget:self action:@selector(createGif) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonGif];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
