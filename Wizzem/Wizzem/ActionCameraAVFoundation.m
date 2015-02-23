//
//  ActionCameraAVFoundation.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ActionCameraAVFoundation.h"

@implementation ActionCameraAVFoundation

#pragma mark - take photo

+ (void) takePhoto:(void(^)(UIImage *))blockCompletion {
    AVCaptureConnection *videoConnection;
    
    if ((videoConnection = [CameraAVFoundation getCaptureConnection]) == nil) {
        blockCompletion(nil);
        return;
    }
    
    [[CameraAVFoundation sharedInstace].stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            blockCompletion(image);
        }
        else {
            blockCompletion(nil);
        }
    }];
}

@end
