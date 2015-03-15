//
//  DetailCameraViewController.m
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <FLAnimatedImage.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DetailCameraViewController.h"

@interface DetailCameraViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayer;
@end

@implementation DetailCameraViewController

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void) initGifImageView {
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:self.gif];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

- (void) initImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.imageView];
}

- (void) dismissMoviePlayer {
    [self.moviePlayer dismissViewControllerAnimated:true completion:nil];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) initMovieView:(NSURL *)url {
    self.moviePlayer=[[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissMoviePlayer)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    self.moviePlayer.moviePlayer.shouldAutoplay = false;
    self.moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self.moviePlayer.moviePlayer prepareToPlay];
    [self.moviePlayer.moviePlayer play];
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.cameraKind == VIDEO_CAMERA) {
        [self initMovieView:self.urlMovie];
    }
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
