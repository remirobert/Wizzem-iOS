//
//  CameraAVFoundation.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "CameraAVFoundation.h"

@interface CameraAVFoundation()
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@end

# define CAMERA_QUALITY            AVCaptureSessionPresetHigh

@implementation CameraAVFoundation

#pragma mark - Camera device management

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            self.currentDevicePosition = AVCaptureDevicePositionFront;
            return (device);
        }
    }
    return (nil);
}

- (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            self.currentDevicePosition = AVCaptureDevicePositionBack;
            return (device);
        }
    }
    return (nil);
}

- (void) switchDeviceCamera {
    NSArray *inputs = self.session.inputs;
    for (AVCaptureDeviceInput *currentInput in inputs ) {
        AVCaptureDevice *device = (_currentDevicePosition == AVCaptureDevicePositionBack) ?
        [self frontCamera] : [self backCamera];
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDeviceInput *newInput = nil;
            
            newInput =  [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            [self.session beginConfiguration];
            [self.session removeInput:currentInput];
            [self.session addInput:newInput];
            [self.session commitConfiguration];
            
            break ;
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
    
    AVCaptureDevice *device = [self backCamera];
    
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


+ (CameraAVFoundation *) sharedInstace {
    static dispatch_once_t onceToken;
    static CameraAVFoundation *cameraFoundation;
    
    dispatch_once(&onceToken, ^{
        cameraFoundation = [[CameraAVFoundation alloc] init];
        [cameraFoundation initAvFoundation];
    });
    return cameraFoundation;
}

@end
