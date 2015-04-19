//
//  MakeAnimatedImage.m
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "MakeAnimatedImage.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation MakeAnimatedImage

+(void)saveGIFFromImages:(NSArray*)images toPath:(NSString *)path WithCallbackBlock:(void (^)(void))callbackBlock{
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
    NSDictionary *prep = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.2f] forKey:(NSString *) kCGImagePropertyGIFDelayTime] forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    
    CGImageDestinationRef dst = CGImageDestinationCreateWithURL(url, kUTTypeGIF, [images count], nil);
    CGImageDestinationSetProperties(dst, (__bridge CFDictionaryRef)fileProperties);
    
    for (int i=0;i<[images count];i++)
    {
        //load anImage from array
        UIImage * anImage = [images objectAtIndex:i];
        NSLog(@"image : %@", anImage);
        CGImageDestinationAddImage(dst, anImage.CGImage,(__bridge CFDictionaryRef)(prep));
        
    }
    
    bool fileSave = CGImageDestinationFinalize(dst);
    CFRelease(dst);
    if(fileSave) {
        NSLog(@"animated GIF file created at %@", path);
    }else{
        NSLog(@"error: no animated GIF file created at %@", path);
    }
}

+(void)saveGIFToPhotoAlbumFromImages:(NSArray*)images WithCallbackBlock:(void (^)(void))callbackBlock{
    NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"hj_temp.gif"]];
    
    [self saveGIFFromImages:images toPath:tempPath WithCallbackBlock:callbackBlock];
    UIImage * gif_image = [UIImage imageWithContentsOfFile:tempPath];
    UIImageWriteToSavedPhotosAlbum(gif_image, self, nil, nil);
}


+ (void) makeAnimatedGif:(NSArray *)images speedGifFrame:(GifSpeed)speed blockCompletion:(void(^)(NSData *gif))completionBlock {
    NSUInteger kFrameCount = images.count;
    
    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                         @{(__bridge id)kCGImagePropertyGIFLoopCount: @0}};
    
    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                          @{(__bridge id)kCGImagePropertyGIFDelayTime: [NSNumber numberWithFloat:speed],}};
    
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil create:YES error:nil];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];

    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    
    
//    CFMutableDataRef data = CFDataCreateMutable (kCFAllocatorDefault, 0);
//    
//    CGImageDestinationRef destination = CGImageDestinationCreateWithData(data, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    NSLog(@"progress gif creation begin");
    for (UIImage *currentImage in images) {
        //@autoreleasepool {
        
        NSLog(@"progress gif creation image : %@", currentImage);
            CGImageDestinationAddImage(destination, currentImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
        //}
    }
    NSLog(@"progress gif creation finished");
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    NSLog(@"passe okay");
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
//    NSLog(@"1");
//    NSData *gifData = [NSData dataWithData:(__bridge NSData *)data];
//    NSLog(@"2");
    //CFRelease(destination);
    completionBlock(data);
}

@end
