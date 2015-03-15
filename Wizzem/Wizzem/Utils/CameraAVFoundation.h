//
//  CameraAVFoundation.h
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

typedef NS_ENUM(NSInteger, CameraDevicePosition) {
    CameraDeviceFront,
    CameraDeviceRear
};

typedef NS_ENUM(NSInteger, CameraRecordMode) {
    CameraRecordModePhoto,
    CameraRecordModeMovie
};

@interface CameraAVFoundation : NSObject

+ (CameraAVFoundation *) sharedInstace;
+ (void) switchDeviceCamera;
+ (void) changeFlashMode:(AVCaptureTorchMode)mode;
+ (BOOL) isTorchActive;
+ (void) focusAtPoint:(CGPoint)touchPoint;
+ (AVCaptureConnection *) getCaptureConnection;
+ (void) changeCameraOutputMode:(CameraRecordMode)recordMode;

+ (UIView *) previewCamera:(CGSize)size;
+ (UIView *) previewCamera;

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

@property (nonatomic, assign, readonly) CameraDevicePosition currentDevicePosition;
@property (nonatomic, assign, readonly) CameraRecordMode currentCameraMode;

@end