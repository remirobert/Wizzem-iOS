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
#import "MakeAnimatedImage.h"

@interface DetailViewController () <PBJVideoPlayerControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIAlertView *alertPop;
@property (nonatomic, strong) UIActivityViewController *activityController;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation DetailViewController

#pragma mark -
#pragma mark share media

- (UIActivityViewController *)activityController {
    if (!_activityController) {
        NSArray *data;
        if (self.media.mediaType == WizzMediaPhoto) {
            data = @[[self.media photo]];
        }
        else if (self.media.mediaType == WizzMediaVideo) {
            NSURL *urlVideo = [NSURL URLWithString:[self.media video]];
            NSLog(@"url video : %@", urlVideo);
            NSData *videoData = [NSData dataWithContentsOfURL:urlVideo];
            NSLog(@"size data : %d", videoData.length);
            
            if (!videoData) {
                NSLog(@"video data is nil");
            }
            
            data = @[videoData];
        }
        else if (self.media.mediaType == WizzMediaText) {
            data = @[[[self.media text] objectForKey:@"text"]];
        }
        NSLog(@"data video : %@", [WizzMedia dataFromFile:[self.media video]]);
        NSLog(@"data listing : %@", data);
        _activityController = [[UIActivityViewController alloc] initWithActivityItems:data applicationActivities:nil];
    }
    return _activityController;
}

- (IBAction)shareMedia:(id)sender {
    if (self.activityController) {
        [self.navigationController presentViewController:self.activityController animated:true completion:nil];
    }
    else {
        NSLog(@"controller activity nil");
    }
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}

- (void)dismissController {
    if (self.media.mediaType == WizzMediaText) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }
    else {
        [self.alertPop show];
    }
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
        
//        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//        [back setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//        [back addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
//        back.frame = CGRectMake(10, 10, 40, 40);
//        back.tintColor = [UIColor colorWithRed:0.25 green:0.24 blue:0.3 alpha:1];
//        [_navigationBar addSubview:back];
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
        _textView.textAlignment = NSTextAlignmentJustified;
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

#pragma mark photo

- (void)displayPhoto {
    self.imageView.image = [self.media photo];
    [self.view addSubview:self.imageView];
}

#pragma mark gif

- (void)changeSpeed:(UIButton *)sender {
    float speed;
    if (sender.tag == 0) {
        speed = GIF_SPEED_SLOW;
    }
    else if (sender.tag == 1) {
        speed = GIF_SPEED_NORMAL;
    }
    else {
        speed = GIF_SPEED_FAST;
    }
    [MakeAnimatedImage makeAnimatedGif:[[self.media gif] objectForKey:@"photos"] speedGifFrame:speed blockCompletion:^(NSData *gif) {
        FLAnimatedImage *img = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gif];
        self.imageView.animatedImage = img;
    }];
}

- (void)displayGif {
    
    UIButton *speed = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width + 64, self.view.frame.size.width / 3, 30)];
    [speed setTitle:@"slow" forState:UIControlStateNormal];
    speed.tag = 0;
    [speed addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speed];
    
    UIButton *normal = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width + 64, self.view.frame.size.width / 3, 30)];
    [normal setTitle:@"normal" forState:UIControlStateNormal];
    normal.tag = 1;
    [normal addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normal];
    
    UIButton *fast = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3 * 2, self.view.frame.size.width + 64, self.view.frame.size.width / 3, 30)];
    [fast setTitle:@"fast" forState:UIControlStateNormal];
    fast.tag = 2;
    [fast addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fast];

    [self.view addSubview:speed];
    [self.view addSubview:normal];
    [self.view addSubview:fast];
    
    NSDictionary *gifContent = [self.media gif];
    FLAnimatedImage *img = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[gifContent objectForKey:@"data"]];
    self.imageView.animatedImage = img;
    [self.view addSubview:self.imageView];
}

#pragma mark video

- (void)displayVideo {
    self.videoPlayerController.videoPath = [self.media video];
}

#pragma mark song

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

#pragma mark text

- (void)displayText {
    NSDictionary *contentText = [self.media text];
    self.textView.text = [contentText objectForKey:@"text"];
    self.textView.textColor = [contentText objectForKey:@"textColor"];
    self.textView.backgroundColor = [contentText objectForKey:@"backgroundColor"];
    [self.view addSubview:self.textView];
}

#pragma mark -
#pragma mark media model handler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.shareButton setImage:[[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    [[self navigationController] setNavigationBarHidden:YES animated:false];
    self.view.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
    [self.view addSubview:self.navigationBar];
    
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
