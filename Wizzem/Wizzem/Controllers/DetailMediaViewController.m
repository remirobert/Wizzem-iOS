//
//  DetailMediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 22/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <FLAnimatedImage.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DetailMediaViewController.h"
#import "Wizzem-Swift.h"
#import "Colors.h"
#import "Header.h"
#import "WizzMedia.h"

@interface DetailMediaViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FLAnimatedImageView *gifView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end

@implementation DetailMediaViewController

#pragma mark -
#pragma mark lazy init Preview media

- (FLAnimatedImageView *)gifView {
    if (!_gifView) {
        FLAnimatedImage *gif = [FLAnimatedImage animatedImageWithGIFData:[self.mediaModel gif]];
        
        _gifView = [[FLAnimatedImageView alloc] init];
        _gifView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        _gifView.animatedImage = gif;
    }
    return _gifView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.image = [self.mediaModel photo];
    }
    return _imageView;
}

- (MPMoviePlayerController *)moviePlayer {
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[self.mediaModel video]];
        _moviePlayer.fullscreen = YES;
        _moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        [_moviePlayer prepareToPlay];
    }
    return _moviePlayer;
}

#pragma mark -
#pragma mark view cycle

- (void)viewDidLayoutSubviews {
    switch (self.mediaModel.mediaType) {
        case WizzMediaPhoto:
            [self.view addSubview:self.imageView];
            break;
            
        case WizzMediaGif: {
            [self.view addSubview:self.gifView];
        }
            
        case WizzMediaVideo: {
             [self.moviePlayer setFullscreen:false animated:YES];
            [self.view addSubview:_moviePlayer.view];
            [_moviePlayer play];
        }
        
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
