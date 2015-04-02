//
//  SongCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 02/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SongCaptureViewController.h"
#import "WizzMedia.h"

@interface SongCaptureViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewRecord;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end

@implementation SongCaptureViewController

- (void)startRecording {
    [WizzMedia startRecordSong:^(NSURL *song) {
        self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaSong genericObjectMedia:song];
        [self displayMedia];
    }];
}

- (void)pauseRecording {
    [WizzMedia pauseRecordSong];
}

- (void)resumeRecording {
    [WizzMedia resumeRecordSong];
}

- (IBAction)stopRecording:(id)sender {
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
}

@end
