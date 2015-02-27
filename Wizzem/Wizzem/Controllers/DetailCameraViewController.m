//
//  DetailCameraViewController.m
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <FLAnimatedImage.h>
#import "DetailCameraViewController.h"

@interface DetailCameraViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DetailCameraViewController

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void) initGifImageView {
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:self.gif];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
}

- (void) initImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.image = self.image;
    
    [self.view addSubview:self.imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.cameraKind == PHOTO_CAMERA) {
        [self initImageView];
    }
    else if (self.cameraKind == GIF_CAMERA) {
        [self initGifImageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
