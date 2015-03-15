//
//  ActionMovieRecordAVFoundation.m
//  Wizzem
//
//  Created by Remi Robert on 01/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMTime.h>
#import "ActionMovieRecordAVFoundation.h"
#import "CameraAVFoundation.h"

@interface ActionMovieRecordAVFoundation()
@property (nonatomic, assign, readwrite) BOOL isRecording;
@property (nonatomic, strong) void (^completion)(NSURL *url);
@property (nonatomic, strong) NSTimer *timerMovieRecord;
@property (nonatomic, strong) NSURL *movieRecordUrl;
@end

@implementation ActionMovieRecordAVFoundation

# define MAX_DURATION_VIDEO     10.0f

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
    [ActionMovieRecordAVFoundation cropVideo:self.movieRecordUrl];
    [ActionMovieRecordAVFoundation sharedInstance].completion(outputFileURL);
    return;
}

+ (void) cropVideo:(NSURL *)url {
    
    //load our movie Asset
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    NSLog(@"%@", [asset tracksWithMediaType:AVMediaTypeVideo]);
    //create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //create a video composition and preset some settings
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    //here we are setting its render size to its height x height (Square)
    NSLog(@"size natural size : %f %f", clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
    
    //create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));
    
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    //Here we shift the viewing square up to the TOP of the video so we only see the top
    //CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, 0 );
    
    //Use this code if you want the viewing square to be in the middle of the video
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );    
    //Make sure the square is portrait
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    
    //add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    //Create an Export Path to store the cropped video
    //Remove any prevouis videos at that path
    [[NSFileManager defaultManager]  removeItemAtURL:url error:nil];
    
    
    AVAssetExportSession *exporter;
    exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
    exporter.videoComposition = videoComposition;
    exporter.outputURL = url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             //Call when finished
             NSLog(@"exporter url : %@", exporter.outputURL);
            //[self exportDidFinish:exporter];
         });
     }];
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
    self.movieRecordUrl = outputURL;
    [[CameraAVFoundation sharedInstace].movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    [ActionMovieRecordAVFoundation sharedInstance].timerMovieRecord = [NSTimer scheduledTimerWithTimeInterval:MAX_DURATION_VIDEO target:self selector:@selector(stopMovieRecording) userInfo:nil repeats:false];
    
    [[NSRunLoop mainRunLoop] addTimer:[ActionMovieRecordAVFoundation sharedInstance].timerMovieRecord forMode:NSRunLoopCommonModes];
    self.isRecording = true;
}

- (void) stopMovieRecording {
    if ([ActionMovieRecordAVFoundation sharedInstance].timerMovieRecord) {
        [[ActionMovieRecordAVFoundation sharedInstance].timerMovieRecord invalidate];
        [ActionMovieRecordAVFoundation sharedInstance].timerMovieRecord = nil;
    }
    [[CameraAVFoundation sharedInstace].movieFileOutput stopRecording];
    self.isRecording = false;
}

#pragma mark - helpers camera video

+ (void) startMovieRecording:(void (^)(NSURL *url))completion {
    if ([CameraAVFoundation sharedInstace].currentCameraMode != CameraRecordModeMovie ||
        [ActionMovieRecordAVFoundation sharedInstance].isRecording == true) {
        return;
    }
    [ActionMovieRecordAVFoundation sharedInstance].completion = [completion copy];
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
