//
//  GifMaker.m
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "GifMaker.h"

@implementation GifMaker

- (void) makeAnimatedGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock {
    NSUInteger kFrameCount = images.count;
    
    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                         @{(__bridge id)kCGImagePropertyGIFLoopCount: @0}};
    
    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                          @{(__bridge id)kCGImagePropertyGIFDelayTime: DEFAULT_SPEED_GIF,}};
    
    //    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
    //                                                                          inDomain:NSUserDomainMask
    //                                                                 appropriateForURL:nil create:YES error:nil];
    //    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    CFMutableDataRef data = CFDataCreateMutable (kCFAllocatorDefault, 0);
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(data, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (UIImage *currentImage in images) {
        @autoreleasepool {
            CGImageDestinationAddImage(destination, currentImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    NSData *gifData = [NSData dataWithData:(__bridge NSData *)data];
    CFRelease(destination);
    completionBlock(gifData);
}

@end
