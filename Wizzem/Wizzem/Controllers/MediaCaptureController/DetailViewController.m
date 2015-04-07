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
#import <MediaPlayer/MediaPlayer.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Header.h"

@interface DetailViewController () <PBJVideoPlayerControllerDelegate>
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
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

- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

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

- (void)playSong {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [session setActive:true error:nil];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:[self.media audio]
                        error:&error];
    
    NSLog(@"error : %@", error);
    if (![self.audioPlayer prepareToPlay]) {
        NSLog(@"error prepare to play");
    }
    else {
        NSLog(@"ok prepare to play");
    }
    if (![self.audioPlayer play]) {
        NSLog(@"error to play");
    }
    else {
        NSLog(@"ok to play");
    }
}

#pragma mark -
#pragma mark media model handler

- (void) viewDidLayoutSubviews {
    switch (self.media.mediaType) {
        case WizzMediaPhoto:
            [self.assetsLibrary saveImage:[self.media photo] toAlbum:ALBUM_MEDIA completion:nil failure:nil];
            [self displayPhoto];
            break;
            
        case WizzMediaGif:
            [self displayGif];
            break;
            
        case WizzMediaVideo:
            [self.assetsLibrary saveVideo:[NSURL URLWithString:[self.media video]] toAlbum:ALBUM_MEDIA completion:nil failure:nil];
            [self displayVideo];
            break;
            
        case WizzMediaSong:
            [self playSong];
            break;
            
        default:
            break;
    }
}

@end
