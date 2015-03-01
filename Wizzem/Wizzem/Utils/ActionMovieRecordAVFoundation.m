//
//  ActionMovieRecordAVFoundation.m
//  Wizzem
//
//  Created by Remi Robert on 01/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ActionMovieRecordAVFoundation.h"
#import "CameraAVFoundation.h"

@interface ActionMovieRecordAVFoundation()
@property (nonatomic, assign, readwrite) BOOL isRecording;
@end

@implementation ActionMovieRecordAVFoundation

#pragma mark - shared instance

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    static ActionMovieRecordAVFoundation *movieAction;
    
    dispatch_once(&onceToken, ^{
        movieAction = [[ActionMovieRecordAVFoundation alloc] init];
        movieAction.isRecording = false;
    });
    return (movieAction);
}

#pragma mark - delegate capture

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error {
    
}

#pragma mark - start / stop recording

- (void) startMovieRecording {
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO) {
            return;
        }
    }
    [[CameraAVFoundation sharedInstace].movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    self.isRecording = true;
}

- (void) stopMovieRecording {
    [[CameraAVFoundation sharedInstace].movieFileOutput stopRecording];
    self.isRecording = false;
}

#pragma mark - helpers camera video

+ (void) startMovieRecording {
    if ([CameraAVFoundation sharedInstace].currentCameraMode != CameraRecordModeMovie ||
        [ActionMovieRecordAVFoundation sharedInstance].isRecording == true) {
        return;
    }
    [[ActionMovieRecordAVFoundation sharedInstance] startMovieRecording];
}

+ (void) stopMovieRecording {
    if ([CameraAVFoundation sharedInstace].currentCameraMode != CameraRecordModeMovie ||
        [ActionMovieRecordAVFoundation sharedInstance].isRecording == false) {
        return;
    }
    [[ActionMovieRecordAVFoundation sharedInstance] stopMovieRecording];
}

@end
