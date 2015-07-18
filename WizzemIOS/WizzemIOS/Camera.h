//
//  Camera.h
//  
//
//  Created by Remi Robert on 03/07/15.
//
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#define READY_TO_CAPTURE_NOTIFICATION  @"cameraengine.raedycapture.com"

@interface Camera : NSObject

+ (instancetype)shareInstance;
- (AVCaptureVideoPreviewLayer *)getPreviewLayer;
- (void)startSession;
- (void)stopSession;

- (void)changeCamera;
- (void)capturePhotoWithCompletion:(void (^)(NSData *image))block;
@end
