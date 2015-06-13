//
//  GifMaker.h
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

# define DEFAULT_SPEED_GIF              @0.5f

@interface GifMaker : NSObject

- (void)makeAnimatedGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock;

@end
