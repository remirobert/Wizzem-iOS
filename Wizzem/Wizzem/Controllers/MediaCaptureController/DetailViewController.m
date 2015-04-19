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
#import "Colors.h"

@interface DetailViewController () <PBJVideoPlayerControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIAlertView *alertPop;
@end

@implementation DetailViewController

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}

- (void)dismissController {
    [self.alertPop show];
    //[self.navigationController popToRootViewControllerAnimated:true];
}

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

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _navigationBar.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(10, 10, 40, 40);
        back.tintColor = [UIColor colorWithRed:0.25 green:0.24 blue:0.3 alpha:1];
        [_navigationBar addSubview:back];
    }
    return _navigationBar;
}

#pragma mark media

- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (FLAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width,
                                                                           [UIScreen mainScreen].bounds.size.width)];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (PBJVideoPlayerController *)videoPlayerController {
    if (!_videoPlayerController) {
        _videoPlayerController = [[PBJVideoPlayerController alloc] init];
        _videoPlayerController.delegate = self;
        _videoPlayerController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width);
        [self addChildViewController:_videoPlayerController];
        [self.view addSubview:_videoPlayerController.view];
        [_videoPlayerController didMoveToParentViewController:self];
    }
    return _videoPlayerController;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
        _textView.editable = false;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.font = [UIFont boldSystemFontOfSize:22];
        _textView.textAlignment = NSTextAlignmentCenter;
    }
    return _textView;
}

- (UIAlertView *)alertPop {
    if (!_alertPop) {
        _alertPop = [[UIAlertView alloc] initWithTitle:@"Voullez vous annuler ?" message:@"Le media va être détruit" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Retour", nil];
    }
    return  _alertPop;
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

- (void)displayText {
    NSDictionary *contentText = [self.media text];
    self.textView.text = [contentText objectForKey:@"text"];
    self.textView.textColor = [contentText objectForKey:@"textColor"];
    self.textView.backgroundColor = [contentText objectForKey:@"backgroundColor"];
    [self.view addSubview:self.textView];
}

#pragma mark -
#pragma mark media model handler

- (void) viewDidAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:false];
    self.view.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
    [self.view addSubview:self.navigationBar];
    
    switch (self.media.mediaType) {
        case WizzMediaPhoto:
            
            
            [self.assetsLibrary saveImage:[self.media photo] toAlbum:ALBUM_MEDIA completion:^(NSURL *assetURL, NSError *error) {
                
            } failure:^(NSError *error) {
                
            }];
            [self displayPhoto];
            break;
            
        case WizzMediaGif:
            [self displayGif];
            break;
            
        case WizzMediaVideo:
            [self.assetsLibrary saveVideo:[NSURL URLWithString:[self.media video]] toAlbum:ALBUM_MEDIA completion:^(NSURL *assetURL, NSError *error) {
                
            } failure:^(NSError *error) {
                
            }];
            [self displayVideo];
            break;
            
        case WizzMediaSong:
            [self playSong];
            break;
            
        case WizzMediaText:
            [self displayText];
            break;
            
        default:
            break;
    }

}

@end
