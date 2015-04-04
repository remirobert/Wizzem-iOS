//
//  SongCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 02/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SongCaptureViewController.h"
#import "WizzMedia.h"
#import "DismissButton.h"

@interface SongCaptureViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewRecord;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) DismissButton *crossButton;
@end

@implementation SongCaptureViewController

- (void)startRecording {
    self.isRecording = true;
    NSLog(@"start recording");
    [WizzMedia startRecordSong:^(NSURL *song) {
        NSLog(@"record get song : %@", song);
        self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaSong genericObjectMedia:song];
        [self displayMedia];
    }];
}

- (void)pauseRecording {
    NSLog(@"pause recording");
    if (self.isRecording) {
        [WizzMedia pauseRecordSong];
    }
}

- (void)resumeRecording {
    NSLog(@"resume recording");
    if (self.isRecording) {
        [WizzMedia resumeRecordSong];
    }
}

- (IBAction)stopRecording:(id)sender {
    NSLog(@"stop recording");
    self.isRecording = false;
    [WizzMedia stopRecordSong];
}

#pragma mark -
#pragma mark handle gesture capture

- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!self.isRecording)
                [self startRecording];
            else
                [self resumeRecording];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self pauseRecording];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark setter getter

- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (!_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        _longPressGestureRecognizer.delegate = self;
        _longPressGestureRecognizer.minimumPressDuration = 0.05f;
        _longPressGestureRecognizer.allowableMovement = 10.0f;
    }
    return _longPressGestureRecognizer;
}

#pragma mark -
#pragma UIView cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewRecord addGestureRecognizer:self.longPressGestureRecognizer];
    self.isRecording = false;
    
    self.crossButton = [[DismissButton alloc] initWithFrame:CGRectMake(10, 300, 40, 40)];
    [self.crossButton addTarget:self action:@selector(dismissMediaController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crossButton];
}

@end
