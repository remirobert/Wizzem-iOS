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
@property (nonatomic, strong) void (^completion)(NSURL *url);
@end

@implementation ActionMovieRecordAVFoundation

# define MAX_DURATION_VIDEO     4

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

+ (BOOL) isRecording {
    return [ActionMovieRecordAVFoundation sharedInstance].isRecording;
}

#pragma mark - delegate capture

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"error recording : %@", error);
    [ActionMovieRecordAVFoundation sharedInstance].completion(outputFileURL);
    return;
}

#pragma mark - start / stop recordings

- (void) startMovieRecording {
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO) {
            NSLog(@"error file %@", error);
            return;
        }
    }
    Float64 TotalSeconds = MAX_DURATION_VIDEO;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    
    [CameraAVFoundation sharedInstace].movieFileOutput.maxRecordedDuration = maxDuration;
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

+ (void) stopMovieRecording:(void (^)(NSURL *url))completion {
    if ([CameraAVFoundation sharedInstace].currentCameraMode != CameraRecordModeMovie ||
        [ActionMovieRecordAVFoundation sharedInstance].isRecording == false) {
        return;
    }
    [ActionMovieRecordAVFoundation sharedInstance].completion = [completion copy];
    [[ActionMovieRecordAVFoundation sharedInstance] stopMovieRecording];
}

@end
