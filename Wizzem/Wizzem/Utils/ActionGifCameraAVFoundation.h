//
//  ActionGifCameraAVFoundation.h
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionGifCameraAVFoundation : NSObject

@property (nonatomic, assign) BOOL isWorking;

+ (ActionGifCameraAVFoundation *) sharedInstance;
+ (void) makeAnimatedGif:(void(^)(NSURL *fileUrl))completionBlock;
+ (void) releaseImages;
+ (void) addImage;

@end
