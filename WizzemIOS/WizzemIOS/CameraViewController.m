//
//  CameraViewController.m
//  Wizzem
//
//  Created by Remi Robert on 03/07/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"
#import "Camera.h"
#import "FlashLabel.h"
#import "CaptureButton.h"
#import "PreviewCaptureViewController.h"
#import "GifMaker.h"
#import "PhotoHelper.h"

typedef enum : NSUInteger {
    PHOTO_MODE,
    GIF_MODE,
} CaptureMode;

@interface CameraViewController ()
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *validateGifButton;
@property (strong, nonatomic) IBOutlet UIButton *resetGifButton;
@property (strong, nonatomic) IBOutlet UIButton *photoModeButton;
@property (strong, nonatomic) IBOutlet UIButton *gifModeButton;
@property (strong, nonatomic) IBOutlet FlashLabel *flashLabel;
@property (strong, nonatomic) IBOutlet CaptureButton *captureButton;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) CaptureMode mode;
@end

@implementation CameraViewController

#pragma mark -
#pragma mark Capture action

- (IBAction)changeToPhotoMode:(id)sender {
    if (self.mode == PHOTO_MODE) {
        return;
    }
    [self.flashLabel flashText:@"Photo"];
    self.mode = PHOTO_MODE;
}

- (IBAction)changeToGifMode:(id)sender {
    if (self.mode == GIF_MODE) {
        return;
    }
    [self.flashLabel flashText:@"Gif"];
    self.mode = GIF_MODE;
    self.photos = [NSMutableArray array];
}

- (IBAction)captureMedia:(id)sender {
    [self.captureButton animatedClick];
    
    if (self.mode == PHOTO_MODE) {
        [[Camera shareInstance] capturePhotoWithCompletion:^(NSData *image) {
            [self performSegueWithIdentifier:@"previewCaptureSegue" sender:image];
        }];
    }
    else {
        [[Camera shareInstance] capturePhotoWithCompletion:^(NSData *dataImage) {
            NSData *compressData = UIImageJPEGRepresentation([UIImage imageWithData:dataImage], 0.1);
            UIImage *fixImage = [PhotoHelper fixOrientationOfImage:[UIImage imageWithData:compressData]];
            [self.photos addObject:fixImage];
            if (self.photos.count >= 1) {
                self.validateGifButton.alpha = 1;
                self.resetGifButton.alpha = 1;
            }
            [self.flashLabel flashText:[NSString stringWithFormat:@"%lu", (unsigned long)self.photos.count]];
            if (self.photos.count == 15) {
                [self validateGif:nil];
            }
        }];
    }
}

- (IBAction)validateGif:(id)sender {
    [GifMaker makeAnimatedGif:self.photos blockCompletion:^(NSData *gif) {
        [self performSegueWithIdentifier:@"previewCaptureSegue" sender:gif];
    }];
}

- (IBAction)resetGif:(id)sender {
    [self.photos removeAllObjects];
    self.resetGifButton.alpha = 0;
    self.validateGifButton.alpha = 0;
}

- (IBAction)flipCameraDevice:(id)sender {
    [[Camera shareInstance] changeCamera];
}

#pragma mark -
#pragma mark setup preview capture

- (void)ready {
    AVCaptureVideoPreviewLayer *preview = [[Camera shareInstance] getPreviewLayer];
    preview.frame = self.containerView.frame;
    [self.containerView.layer addSublayer:preview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark controller cycle

- (void)viewDidLayoutSubviews {
}

- (void)viewDidAppear:(BOOL)animated {
    [self resetGif:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mode = PHOTO_MODE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ready) name:READY_TO_CAPTURE_NOTIFICATION object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"previewCaptureSegue"]) {
        ((PreviewCaptureViewController *)segue.destinationViewController).media = [[Media alloc] initWithData:sender andType:(self.mode == PHOTO_MODE) ? PHOTO : GIF];
    }
}

@end
