//
//  GifMaker.m
//  Wizzem
//
//  Created by Remi Robert on 13/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIImage+ImageCompress/UIImage+ImageCompress.h>
#import "GifMaker.h"
#import "MagickWand.h"

@implementation GifMaker

- (void)makeAnimatedGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock {
    MagickWand *mw = NewMagickWand();
    MagickSetFormat(mw, "gif");
    NSLog(@"Going into ImageMagick stuff");
    for (UIImage *img in images) {
        MagickWand *localWand = NewMagickWand();
        UIImage *imgCompressed = [UIImage compressImage:img compressRatio:0.5];
        //UIImage *imgCompressed = [self convertImageToIndexed:img noOfColors:32 withoutTransformation:true];
        NSData *dataObj = UIImageJPEGRepresentation(imgCompressed, 1);
        MagickReadImageBlob(localWand, [dataObj bytes], [dataObj length]);
        MagickQuantizeImage(localWand, 256, MagickGetImageColorspace(localWand), 0, NO, NO);
//        MagickSetImageCompression(localWand, LosslessJPEGCompression);
//        MagickSetImageCompressionQuality(localWand, 0.1);
        MagickSetImageDelay(localWand, 80);
        MagickAddImage(mw, localWand);
        //DestroyMagickWand(localWand);
    }
    size_t my_size;
    NSLog(@"This is the part that takes forever");
    unsigned char * my_image = MagickGetImagesBlob(mw, &my_size);
    NSData *data = [[NSData alloc] initWithBytes:my_image length:my_size];
    free(my_image);
    DestroyMagickWand(mw);
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    path = [NSString stringWithFormat:@"%@/animation.gif", path];
//    NSLog(@"Going to write to file");
//    
//    [data writeToFile:path atomically:YES];
//    NSLog(@"Wrote to file");
//    
//    NSURL *urlzor = [NSURL fileURLWithPath:path];
//    NSLog(@"%@", urlzor);
//    NSLog(@"%@", path);
//    NSData *finalData = [NSData dataWithContentsOfURL:fileURL];
    completionBlock(data);
}

//- (void) makeAnimatedGif:(NSArray *)images blockCompletion:(void(^)(NSData *gif))completionBlock {
//    NSUInteger kFrameCount = images.count;
//    
//    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
//                                         @{(__bridge id)kCGImagePropertyGIFLoopCount: @0}};
//    
//    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
//                                          @{(__bridge id)kCGImagePropertyGIFDelayTime: DEFAULT_SPEED_GIF,}};
//    
////        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
////                                                                              inDomain:NSUserDomainMask
////                                                                     appropriateForURL:nil create:YES error:nil];
////        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
//    
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
//
//    [[NSFileManager defaultManager] removeItemAtPath:[fileURL absoluteString] error:nil];
//
//    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
//    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
//    
//    for (UIImage *currentImage in images) {
//        @autoreleasepool {
//            CGImageDestinationAddImage(destination, currentImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
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

@end
