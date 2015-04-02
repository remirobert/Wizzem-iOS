//
//  DetailViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "DetailViewController.h"
#import <PBJVideoPlayerController.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface DetailViewController () <PBJVideoPlayerControllerDelegate>
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController;
@end

@implementation DetailViewController

#pragma mark -
#pragma mark PBJVideoPlayerControllerDelegate

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer {
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer {
}

- (void)videoPlayerBufferringStateDidChange:(PBJVideoPlayerController *)videoPlayer {
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer {
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer{
}

#pragma mark -
#pragma mark setter getter

- (FLAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                           [UIScreen mainScreen].bounds.size.width)];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (PBJVideoPlayerController *)videoPlayerController {
    if (!_videoPlayerController) {
        _videoPlayerController = [[PBJVideoPlayerController alloc] init];
        _videoPlayerController.delegate = self;
        _videoPlayerController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        [self addChildViewController:_videoPlayerController];
        [self.view addSubview:_videoPlayerController.view];
        [_videoPlayerController didMoveToParentViewController:self];
    }
    return _videoPlayerController;
}

#pragma mark -
#pragma mark visualisation media

- (void)displayPhoto {
    self.imageView.image = [self.media photo];
    [self.view addSubview:self.imageView];
}

- (void)displayGif {
    FLAnimatedImage *img = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[self.media gif]];
    self.imageView.animatedImage = img;
    [self.view addSubview:self.imageView];
}

- (void)displayVideo {
    self.videoPlayerController.videoPath = [self.media video];
}

- (void) viewDidLayoutSubviews {
    switch (self.media.mediaType) {
        case WizzMediaPhoto:
            [self displayPhoto];
            break;
            
        case WizzMediaGif:
            [self displayGif];
            break;
            
        case WizzMediaVideo:
            [self displayVideo];
            break;
            
        default:
            break;
    }
}

@end
