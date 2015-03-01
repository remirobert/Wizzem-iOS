//
//  ActionMovieRecordAVFoundation.h
//  Wizzem
//
//  Created by Remi Robert on 01/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface ActionMovieRecordAVFoundation : NSObject <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, assign, readonly) BOOL isRecording;

@end
