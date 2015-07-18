//
//  GifMaker.m
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ANGifEncoder.h"
#import "ANCutColorTable.h"
#import "ANGifNetscapeAppExtension.h"
#import "GifMaker.h"
#import "UIImagePixelSource.h"

@implementation GifMaker

//+ (void) makeAnimatedGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock {
//    NSUInteger kFrameCount = images.count;
//    
//    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
//                                         @{(__bridge id)kCGImagePropertyGIFLoopCount: @0}};
//    
//    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
//                                          @{(__bridge id)kCGImagePropertyGIFDelayTime: DEFAULT_SPEED_GIF,}};
//    
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
//
//    [[NSFileManager defaultManager] removeItemAtPath:[fileURL absoluteString] error:nil];
//
//    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
//    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
//    
//    
//    for (UIImage *currentImage in images) {
//        @autoreleasepool {
//            NSData *dataCurrentImage = UIImageJPEGRepresentation(currentImage, 0.05);
//            CGImageSourceRef sourceImage = CGImageSourceCreateWithData((__bridge CFDataRef)dataCurrentImage, nil);
//            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceImage, 0, nil);
//            
//            CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
//        }
//    }
//    
//    if (!CGImageDestinationFinalize(destination)) {
//        NSLog(@"failed to finalize image destination");
//    }
//    CFRelease(destination);
//    NSData *data = [NSData dataWithContentsOfURL:fileURL];
//    completionBlock(data);
//}

+ (void)makeAnimatedGif:(NSArray *)images blockCompletion:(void (^)(NSData *))completionBlock {
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    [[NSFileManager defaultManager] removeItemAtPath:[fileURL absoluteString] error:nil];

    ANGifEncoder * encoder = [[ANGifEncoder alloc] initWithOutputFile:[fileURL absoluteString] size:((UIImage *)[images firstObject]).size globalColorTable:nil];
    [encoder addApplicationExtension:[[ANGifNetscapeAppExtension alloc] init]];
    
    for (UIImage *currentImage in images) {
        UIImagePixelSource * pixelSource = [[UIImagePixelSource alloc] initWithImage:currentImage];
        ANCutColorTable * colorTable = [[ANCutColorTable alloc] initWithTransparentFirst:YES pixelSource:pixelSource];
        ANGifImageFrame * frame = [[ANGifImageFrame alloc] initWithPixelSource:pixelSource colorTable:colorTable delayTime:1];
        [encoder addImageFrame:frame];
    }
    [encoder closeFile];
}

@end
