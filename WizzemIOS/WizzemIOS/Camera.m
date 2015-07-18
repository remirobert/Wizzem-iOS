//
//  Camera.m
//  
//
//  Created by Remi Robert on 03/07/15.
//
//

#import "Camera.h"

@interface Camera() <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureStillImageOutput *_imageOutput;
    dispatch_queue_t _captureQueue;
    AVCaptureDeviceInput *_videoDeviceInput;
    
    AVCaptureMovieFileOutput *_movieFileOutput;
    AVCaptureStillImageOutput *_stillImageOutput;

    BOOL _isCapturing;
    void (^completionBlock)(NSURL *videoPath);
}
@end

@implementation Camera

+ (instancetype)shareInstance {
    static Camera *camera;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        camera = [Camera new];
    });
    return camera;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _isCapturing = NO;
    _session = [[AVCaptureSession alloc] init];
    
    _captureQueue = dispatch_queue_create("com.remirobert.wizzem.camera", DISPATCH_QUEUE_SERIAL);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        if ([_session canAddInput:videoDeviceInput]) {
            [_session addInput:videoDeviceInput];
            _videoDeviceInput = videoDeviceInput;
        }

        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([_session canAddOutput:movieFileOutput]) {
            [_session addOutput:movieFileOutput];
            _movieFileOutput = movieFileOutput;
        }
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([_session canAddOutput:stillImageOutput]) {
            [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
            [_session addOutput:stillImageOutput];
            _stillImageOutput = stillImageOutput;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [[NSNotificationCenter defaultCenter] postNotificationName:READY_TO_CAPTURE_NOTIFICATION object:nil];
        });
    });
}

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

- (void)changeCamera
{
    dispatch_async(_captureQueue, ^{
        AVCaptureDevice *currentVideoDevice = [_videoDeviceInput device];
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
        
        switch (currentPosition)
        {
            case AVCaptureDevicePositionUnspecified:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
        }
        
        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [_session beginConfiguration];
        
        [_session removeInput:_videoDeviceInput];
        if ([_session canAddInput:videoDeviceInput]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            [_session addInput:videoDeviceInput];
            _videoDeviceInput = videoDeviceInput;
        }
        else {
            [_session addInput:_videoDeviceInput];
        }
        [_session commitConfiguration];
    });
}

- (AVCaptureVideoPreviewLayer *)getPreviewLayer {
    return _preview;
}

- (void)capturePhotoWithCompletion:(void (^)(NSData *image))block {
    dispatch_async(_captureQueue, ^{
        AVCaptureConnection *connection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        
        [_stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (imageDataSampleBuffer) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                block(imageData);
            }
            else {
                block(nil);
            }
        }];
    });
}

- (void)startSession {
    dispatch_async(_captureQueue, ^{
        [_session startRunning];
    });
}

- (void)stopSession {
    dispatch_async(_captureQueue, ^{
        [_session stopRunning];
    });
}

@end
