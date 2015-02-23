//
//  ActionGifCameraAVFoundation.h
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionGifCameraAVFoundation : NSObject

+ (ActionGifCameraAVFoundation *) sharedInstance;
+ (void) makeAnimatedGif;
+ (void) releaseImages;
+ (void) addImage;

@end
