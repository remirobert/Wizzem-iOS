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
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation DetailMediaViewController {
    dispatch_once_t token;
}

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

- (AVPlayer *)player {
    if (!_player) {
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[self.mediaModel video] options:nil];
        AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:asset];
        _player = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer* lay = [AVPlayerLayer playerLayerWithPlayer:_player];
        lay.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        [self.view.layer addSublayer:lay];
    }
    return _player;
}

- (AVAudioPlayer *)audioPlayer {
    if (_audioPlayer) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
        [session setActive:true error:nil];
        self.audioPlayer = [[AVAudioPlayer alloc]
                            initWithContentsOfURL:[self.mediaModel audio]
                            error:nil];
        [self.audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}

#pragma mark -
#pragma mark view cycle

- (void)viewDidLayoutSubviews {
    dispatch_once(&token, ^{
        switch (self.mediaModel.mediaType) {
            case WizzMediaPhoto:
                [self.view addSubview:self.imageView];
                break;
                
            case WizzMediaGif: {
                [self.view addSubview:self.gifView];
                break;
            }
                
            case WizzMediaVideo: {
                [_player play];
                break;
            }
                
            case WizzMediaSong: {
                [self.audioPlayer play];
                break;
            }
            
            default:
                break;
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    token = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
