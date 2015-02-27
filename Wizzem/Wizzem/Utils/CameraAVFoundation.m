//
//  CameraAVFoundation.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "CameraAVFoundation.h"

@interface CameraAVFoundation()
@property (nonatomic, assign) AVCaptureDevicePosition currentDevicePosition;
@property (nonatomic, strong) AVCaptureSession *session;
@end

# define CAMERA_QUALITY            AVCaptureSessionPresetHigh

@implementation CameraAVFoundation

#pragma mark - Camera device management

+ (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            [self sharedInstace].currentDevicePosition = AVCaptureDevicePositionFront;
            return (device);
        }
    }
    return (nil);
}

+ (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            [self sharedInstace].currentDevicePosition = AVCaptureDevicePositionBack;
            return (device);
        }
    }
    return (nil);
}

+ (void) switchDeviceCamera {
    NSArray *inputs = [self sharedInstace].session.inputs;
    for (AVCaptureDeviceInput *currentInput in inputs ) {
        AVCaptureDevice *device = ([self sharedInstace].currentDevicePosition == AVCaptureDevicePositionBack) ?
        [self frontCamera] : [self backCamera];
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDeviceInput *newInput = nil;
            
            newInput =  [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            [[self sharedInstace].session beginConfiguration];
            [[self sharedInstace].session removeInput:currentInput];
            [[self sharedInstace].session addInput:newInput];
            [[self sharedInstace].session commitConfiguration];
            
            break ;
        }
    }
}

#pragma mark - Focus handle

+ (void) focusAtPoint:(CGPoint)touchPoint {
    AVCaptureDevice *device = [[self sharedInstace].session.inputs.lastObject device];

    if([device isFocusPointOfInterestSupported] &&
       [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        double focus_x = touchPoint.x / screenRect.size.width;
        double focus_y = touchPoint.y / screenRect.size.height;
        if([device lockForConfiguration:nil]) {
            [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];

            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                [device setExposureMode:AVCaptureExposureModeAutoExpose];
            }

            [device unlockForConfiguration];
        }
    }
}

#pragma mark - Init AVFouncation

- (void) initAvFoundation {
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = CAMERA_QUALITY;
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    self.captureVideoPreviewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                [UIScreen mainScreen].bounds.size.height);
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    AVCaptureDevice *device = [CameraAVFoundation backCamera];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) {
        NSLog(@"Error open input device");
        return ;
    }
    [self.session addInput:input];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

#pragma mark - Shared Instance cameraFoundation

+ (CameraAVFoundation *) sharedInstace {
    static dispatch_once_t onceToken;
    static CameraAVFoundation *cameraFoundation;
    
    dispatch_once(&onceToken, ^{
        cameraFoundation = [[CameraAVFoundation alloc] init];
        [cameraFoundation initAvFoundation];
    });
    return cameraFoundation;
}

#pragma mark - helpers

+ (AVCaptureConnection *) getCaptureConnection {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [self sharedInstace].stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                return videoConnection;
            }
        }
    }
    return nil;
}

@end
