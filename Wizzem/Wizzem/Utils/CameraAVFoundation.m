//
//  CameraAVFoundation.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "CameraAVFoundation.h"

@interface CameraAVFoundation()
@property (nonatomic, assign, readwrite) CameraDevicePosition currentDevicePosition;
@property (nonatomic, assign, readwrite) CameraRecordMode currentCameraMode;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDeice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) UIView *previewCamera;
@end

# define CAMERA_QUALITY                 AVCaptureSessionPresetHigh      //Best quality of available on the device
# define FOCUS_TOUCH_ENABLE             true
# define DISPLAY_FOCUS_TOUCH_LAYER      true
# define MAXDURATION_MOVIE_RECORD       kCMTimeInvalid                  //illimited
# define PREFERRED_TIME_SCALE_MOVIE     30                              //FPS
# define MIN_DISK_USE_MOVIE             0                               //illimited
# define DEFAULT_AUDIO_RECORD_MOVIE     true

@implementation CameraAVFoundation

#pragma mark - Camera output management

+ (void) addAudioInputRecord {
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput && [[CameraAVFoundation sharedInstace].session canAddInput:audioInput]) {
        [[CameraAVFoundation sharedInstace].session addInput:audioInput];
    }
}

+ (void) changeCameraOutputMode:(CameraRecordMode)recordMode {
    if ([self sharedInstace].currentCameraMode == recordMode) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AVCaptureOutput *currentOutput = ([self sharedInstace].currentCameraMode == CameraRecordModePhoto) ?
        [self sharedInstace].stillImageOutput : [self sharedInstace].movieFileOutput;
        AVCaptureOutput *newOutput = ([self sharedInstace].currentCameraMode == CameraRecordModePhoto) ?
        [self sharedInstace].movieFileOutput : [self sharedInstace].stillImageOutput;
        
        if ([[self sharedInstace].session canAddOutput:newOutput]) {
            [[self sharedInstace].session beginConfiguration];
            [[self sharedInstace].session removeOutput:currentOutput];
            [[self sharedInstace].session addOutput:newOutput];
            
            if (recordMode == CameraRecordModeMovie && DEFAULT_AUDIO_RECORD_MOVIE) {
                [self addAudioInputRecord];
            }
            
            [[self sharedInstace].session commitConfiguration];
            [self sharedInstace].currentCameraMode = recordMode;
        }
    });
}

#pragma mark - Camera device management

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            self.currentDevicePosition = CameraDeviceFront;
            return (device);
        }
    }
    return (nil);
}

- (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            self.currentDevicePosition = CameraDeviceRear;
            return (device);
        }
    }
    return (nil);
}

+ (void) switchDeviceCamera {
    NSArray *inputs = [self sharedInstace].session.inputs;
    for (AVCaptureDeviceInput *currentInput in inputs ) {
        AVCaptureDevice *device = ([self sharedInstace].currentDevicePosition == AVCaptureDevicePositionBack) ?
        [[self sharedInstace] frontCamera] : [[self sharedInstace] backCamera];
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

#pragma mark - Flash management

+ (AVCaptureDevice *) getCurrentVideoDevice {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device hasFlash]) {
            return device;
        }
    }
    return nil;
}

/*
 AVCaptureTorchModeOff  = 0,
 AVCaptureTorchModeOn   = 1,
 AVCaptureTorchModeAuto = 2,
*/
+ (void) changeFlashMode:(AVCaptureTorchMode)mode {
    AVCaptureDevice *deviceCapture;
    if ((deviceCapture = [self getCurrentVideoDevice])) {
        [[self sharedInstace].session beginConfiguration];
        [deviceCapture lockForConfiguration:nil];
        [deviceCapture setTorchMode:mode];
        [deviceCapture unlockForConfiguration];
        [[self sharedInstace].session commitConfiguration];
    }
}

+ (BOOL) isTorchActive {
    AVCaptureDevice *deviceCapture;
    if ((deviceCapture = [self getCurrentVideoDevice])) {
        return deviceCapture.torchActive;
    }
    return false;
}

#pragma mark - Focus handle

+ (void) focusAtPoint:(CGPoint)touchPoint {
    if (!FOCUS_TOUCH_ENABLE) return;
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

- (void) initMovieOutput {
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
}

- (void) initAvFoundation {
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = CAMERA_QUALITY;
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    self.captureVideoPreviewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                [UIScreen mainScreen].bounds.size.height);
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    AVCaptureDevice *device = [self backCamera];

    self.currentDevicePosition = CameraDeviceRear;
    self.currentCameraMode = CameraRecordModePhoto;
    
    self.inputDeice = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!self.inputDeice) {
        NSLog(@"Error open input device");
        return ;
    }
    [self.session addInput:self.inputDeice];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self initMovieOutput];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

#pragma mark - preview UIView camera

+ (UIView *) previewCamera:(CGSize)size {
    if ([self sharedInstace].previewCamera && CGSizeEqualToSize(size, [self sharedInstace].previewCamera.frame.size)) {
        return [self sharedInstace].previewCamera;
    }
    
    [self sharedInstace].previewCamera = [[UIView alloc] init];
    [self sharedInstace].previewCamera.clipsToBounds = true;
    [self sharedInstace].previewCamera.layer.masksToBounds = true;
    [self sharedInstace].previewCamera.frame = CGRectMake(0, 0, size.width, size.height);
    [self sharedInstace].captureVideoPreviewLayer.frame = CGRectMake(0, -(([self sharedInstace].captureVideoPreviewLayer.frame.size.height - size.height) / 2),
                                                                     [self sharedInstace].captureVideoPreviewLayer.frame.size.width,
                                                                     [self sharedInstace].captureVideoPreviewLayer.frame.size.height);
    [[self sharedInstace].previewCamera.layer addSublayer:[self sharedInstace].captureVideoPreviewLayer];
    return [self sharedInstace].previewCamera;
}

+ (UIView *) previewCamera {
    return [self previewCamera:[UIScreen mainScreen].bounds.size];
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
