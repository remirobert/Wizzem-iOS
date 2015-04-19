//
//  MakeAnimatedImage.h
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GIF_SPEED_SLOW      1.5
#define GIF_SPEED_NORMAL    1.0
#define GIF_SPEED_FAST      0.5

@interface MakeAnimatedImage : NSObject

+ (void)makeAnimatedGif:(NSArray *)images speedGifFrame:(float)speed blockCompletion:(void(^)(NSData *gif))completionBlock;
+ (void)saveGIFToPhotoAlbumFromImages:(NSArray*)images WithCallbackBlock:(void (^)(void))callbackBlock;

@end
