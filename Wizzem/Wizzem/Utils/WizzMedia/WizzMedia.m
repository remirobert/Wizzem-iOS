//
//  WizzMedia.m
//  ExampleWizzMediaFramework
//
//  Created by Remi Robert on 17/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzMedia.h"
#import "WizzMedia+CameraPhoto.h"
#import "WizzMedia+CameraGif.h"
#import "WizzMedia+CameraVideo.h"
#import "WizzMedia+RecordSong.h"
#import "WizzMedia+FileManager.h"

@interface WizzMedia()
@property (nonatomic, assign, readwrite) CameraDevicePosition currentDevicePosition;
@property (nonatomic, assign, readwrite) CameraRecordMode currentCameraMode;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDeice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) UIView *previewCamera;
@property (nonatomic, assign) UIDeviceOrientation currentDeviceOrientation;
@property (nonatomic, strong) NSTimer *timerMovieRecord;
@property (nonatomic, strong) void (^completionRecordMovie)(NSURL *video);
@property (nonatomic, strong) void (^completionRecordSong)(NSURL *song);
@property (nonatomic, assign) BOOL isRecordingMovie;
@end

@implementation WizzMedia

#pragma mark - Shared Instance cameraFoundation

+ (WizzMedia *) sharedInstace {
    static dispatch_once_t onceToken;
    static WizzMedia *cameraFoundation;
    
    dispatch_once(&onceToken, ^{
        cameraFoundation = [[WizzMedia alloc] init];
        [cameraFoundation initAvFoundation];
        cameraFoundation.isRecordingMovie = false;
        cameraFoundation.sizeMedia = DEFAULT_SIZE_MEDIA;
    });
    return cameraFoundation;
}

#pragma mark - Camera output management

+ (void) addAudioInputRecord {
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput && [[WizzMedia sharedInstace].session canAddInput:audioInput]) {
        [[WizzMedia sharedInstace].session addInput:audioInput];
    }
}

+ (void) changeCameraOutputMode:(CameraRecordMode)recordMode blockCompletion:(void(^)())completion {
    if ([self sharedInstace].currentCameraMode == recordMode) {
        completion();
        return;
    }
    
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
        completion();
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

#pragma mark - AVFoundation

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
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(deviceOrientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

+ (void) startSession {
    [[self sharedInstace].session startRunning];
}

+ (void) stopSession {
    [[self sharedInstace].session stopRunning];
}

- (void) deviceOrientationChanged:(NSNotification *)notification {
    UIDevice *device = notification.object;
    self.currentDeviceOrientation = [device orientation];
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

#pragma mark - photo capture handler

+ (void) capturePhoto:(void(^)(UIImage *))blockCompletion {
    [self changeCameraOutputMode:CameraRecordModePhoto blockCompletion:^{
        [[self sharedInstace] takePhoto:^(UIImage *image) {
            blockCompletion([[self sharedInstace] rotate:image withOrientation:[self sharedInstace].currentDeviceOrientation]);
        } videoCaptureConnection:[self getCaptureConnection] andSizeContent:[self sharedInstace].sizeMedia];
    }];
}

+ (void) capturePhoto:(CGSize)sizePhoto andCompletionBlock:(void(^)(UIImage *))blockCompletion {
    [[self sharedInstace] takePhoto:^(UIImage *image) {
        blockCompletion([[self sharedInstace] rotate:image withOrientation:[self sharedInstace].currentDeviceOrientation]);
    } videoCaptureConnection:[self getCaptureConnection] andSizeContent:sizePhoto];
}

+ (void) captureGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock {
    if (images == nil || images.count == 0) {
        completionBlock(nil);
        return;
    }
    [[self sharedInstace] makeAnimatedGif:images blockCompletion:^(NSData *gif) {
        completionBlock(gif);
    }];
}

#pragma mark - movie recording handler

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error {
    if (error) {
        NSLog(@"error recording : %@", error);
        self.completionRecordMovie(nil);
        return;
    }
    self.isRecordingMovie = false;
    [self cropVideo:outputFileURL blockCompletion:^(NSURL *url) {
        self.completionRecordMovie(outputFileURL);
    }];
    return;
}

- (void) startRecording {
    [self.movieFileOutput startRecordingToOutputFileURL:self.movieRecordUrl recordingDelegate:self];
}

+ (void) startRecordMovie:(void(^)(NSURL *))blockCompletion {
    if ([self sharedInstace].isRecordingMovie) {
        return;
    }
    
    [self sharedInstace].isRecordingMovie = true;
    [self changeCameraOutputMode:CameraRecordModeMovie blockCompletion:^{
        [self sharedInstace].completionRecordMovie = blockCompletion;
        [self sharedInstace].timerMovieRecord = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_MAX_DURATION_VIDEO
                                                                                 target:self selector:@selector(stopRecordingMovie) userInfo:nil repeats:false];
        
        [[NSRunLoop mainRunLoop] addTimer:[self sharedInstace].timerMovieRecord forMode:NSRunLoopCommonModes];

        NSURL *outputURL = [WizzMedia urlFile:@"output.mov"];
        if (!outputURL) {
            blockCompletion(nil);
            return;
        }
        
        [self sharedInstace].movieRecordUrl = outputURL;
        [[self sharedInstace] startRecording];
    }];
}

+ (void) stopRecordingMovie {
    if (![self sharedInstace].isRecordingMovie) {
        return;
    }
    if ([self sharedInstace].timerMovieRecord) {
        [[self sharedInstace].timerMovieRecord invalidate];
        [self sharedInstace].timerMovieRecord = nil;
    }
    [[self sharedInstace].movieFileOutput stopRecording];
}

+ (BOOL) isRecordingMovie {
    return [self sharedInstace].isRecordingMovie;
}

#pragma mark - song recording handler

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (!flag) {
        self.completionRecordSong(nil);
    }
    else {
        self.completionRecordSong(recorder.url);
    }
}

- (void) audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"Encode Error occurred : %@", error);
    self.completionRecordSong(nil);
}

- (void) launchSongRecording {
    self.audioRecorder.delegate = self;
    self.audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [self.audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    err = nil;
    [self.audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    if ([self.audioRecorder prepareToRecord]) {
        if (![self.audioRecorder record]) {
            self.completionRecordSong(nil);
        }
    }
    else {
        self.completionRecordSong(nil);
    }

}

+ (void) startRecordSong:(void(^)(NSURL *))blockCompletion {
    if (![self sharedInstace].audioRecorder) {
        
        NSURL *outputURL = [WizzMedia urlFile:@"output.caf"];
        if (!outputURL) {
            blockCompletion(nil);
            return;
        }
        
        NSError *error;
        [self sharedInstace].audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputURL settings:[[self sharedInstace] recordingSetting] error:&error];
        if (error || ![self sharedInstace].audioRecorder) {
            NSLog(@"error recorder : %@", error);
            blockCompletion(nil);
            return ;
        }
        [self sharedInstace].audioRecorder.delegate = [self sharedInstace];
    }
    [self sharedInstace].completionRecordSong = blockCompletion;
    [[self sharedInstace] launchSongRecording];
}

+ (void) stopRecordSong {
    if ([self sharedInstace].audioRecorder) {
        NSLog(@"stop ok");
        [[self sharedInstace].audioRecorder stop];
        [[self sharedInstace].audioSession setActive:false error:nil];
    }
}

+ (void) pauseRecordSong {
    if ([self sharedInstace].audioRecorder && [[self sharedInstace].audioRecorder isRecording]) {
        [[self sharedInstace].audioRecorder pause];
    }
}

+ (void) resumeRecordSong {
    if ([self sharedInstace].audioRecorder) {
        [[self sharedInstace].audioRecorder record];
    }
}

+ (BOOL) isRecordingSong {
    if (![self sharedInstace].audioRecorder) {
        return false;
    }
    return [[self sharedInstace].audioRecorder isRecording];
}

@end
