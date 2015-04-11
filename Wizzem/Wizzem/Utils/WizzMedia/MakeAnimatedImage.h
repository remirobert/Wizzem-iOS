//
//  MakeAnimatedImage.h
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeAnimatedImage : NSObject

+ (void) makeAnimatedGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock;
+(void)saveGIFToPhotoAlbumFromImages:(NSArray*)images WithCallbackBlock:(void (^)(void))callbackBlock;

@end
