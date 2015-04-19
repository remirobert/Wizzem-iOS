//
//  MakeAnimatedImage.h
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GifSpeedSlow = 1.5,
    GifSpeedNormal = 1,
    GifSpeedFast = 0.5,
} GifSpeed;

@interface MakeAnimatedImage : NSObject

+ (void)makeAnimatedGif:(NSArray *)images speedGifFrame:(GifSpeed)speed blockCompletion:(void(^)(NSData *gif))completionBlock;
+ (void)saveGIFToPhotoAlbumFromImages:(NSArray*)images WithCallbackBlock:(void (^)(void))callbackBlock;

@end
