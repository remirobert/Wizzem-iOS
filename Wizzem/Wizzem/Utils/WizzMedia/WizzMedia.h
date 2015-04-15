//
//  WizzMedia.h
//  ExampleWizzMediaFramework
//
//  Created by Remi Robert on 17/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

# define CAMERA_QUALITY                 AVCaptureSessionPresetHigh      //Best quality of available on the device
# define FOCUS_TOUCH_ENABLE             true
# define DISPLAY_FOCUS_TOUCH_LAYER      true
# define MAXDURATION_MOVIE_RECORD       kCMTimeInvalid                  //illimited
# define PREFERRED_TIME_SCALE_MOVIE     30                              //FPS
# define MIN_DISK_USE_MOVIE             0                               //illimited
# define DEFAULT_AUDIO_RECORD_MOVIE     true
# define DEFAULT_SIZE_MEDIA             CGSizeMake(1080, 1080)
# define DEFAULT_SPEED_GIF              @0.5f
# define DEFAULT_MAX_DURATION_VIDEO     10.0f
# define DEFAULT_RECORD_ENCODING        ENC_IMA4

typedef NS_ENUM(NSInteger, WizzMediaType) {
    WizzMediaPhoto,
    WizzMediaVideo,
    WizzMediaGif,
    WizzMediaSong,
    WizzMediaText
};

typedef NS_ENUM(NSInteger, CameraDevicePosition) {
    CameraDeviceFront,
    CameraDeviceRear
};

typedef NS_ENUM(NSInteger, CameraRecordMode) {
    CameraRecordModePhoto,
    CameraRecordModeMovie
};

typedef NS_ENUM(NSInteger, SongEncodingTypes) {
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
};

@interface WizzMedia : NSObject <AVCaptureFileOutputRecordingDelegate, AVAudioRecorderDelegate>

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

@property (nonatomic, assign, readonly) CameraDevicePosition currentDevicePosition;
@property (nonatomic, assign, readonly) CameraRecordMode currentCameraMode;

@property (nonatomic, assign) CGSize sizeMedia;

@property (nonatomic, assign) float maxDurationMovieRecording;
@property (nonatomic, strong) NSURL *movieRecordUrl;
@property (nonatomic, assign, readonly) BOOL isRecordingMovie;

@property (nonatomic, assign) SongEncodingTypes songRecordEncoding;

+ (void) startSession;
+ (void) stopSession;

+ (UIView *) previewCamera:(CGSize)size;
+ (UIView *) previewCamera;

+ (void) switchDeviceCamera;

+ (void) capturePhoto:(void(^)(UIImage *image))blockCompletion;
+ (void) capturePhoto:(CGSize)sizePhoto andCompletionBlock:(void(^)(UIImage *image))blockCompletio;

+ (void) captureGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock;

+ (void) startRecordMovie:(void(^)(NSURL *movie))blockCompletion;
+ (void) stopRecordingMovie;
+ (BOOL) isRecordingMovie;

+ (void) startRecordSong:(void(^)(NSURL *song))blockCompletion;
+ (void) stopRecordSong;
+ (void) pauseRecordSong;
+ (void) resumeRecordSong;
+ (BOOL) isRecordingSong;
+ (NSTimeInterval)currentTime;

@end
