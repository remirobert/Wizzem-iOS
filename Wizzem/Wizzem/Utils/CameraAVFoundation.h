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

@interface CameraAVFoundation : NSObject

+ (CameraAVFoundation *) sharedInstace;
+ (void) switchDeviceCamera;
+ (void) focusAtPoint:(CGPoint)touchPoint;
+ (AVCaptureConnection *) getCaptureConnection;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@end
