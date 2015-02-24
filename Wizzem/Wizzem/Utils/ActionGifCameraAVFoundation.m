//
//  ActionGifCameraAVFoundation.m
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ActionGifCameraAVFoundation.h"
#import "ActionCameraAVFoundation.h"

@interface ActionGifCameraAVFoundation()
@property (nonatomic, strong) NSMutableArray *images;
@end

# define DEFAULT_SPEED_GIF      @0.5f

@implementation ActionGifCameraAVFoundation

+ (ActionGifCameraAVFoundation *) sharedInstance {
    static dispatch_once_t onceToken;
    static ActionGifCameraAVFoundation *actionGifAVFoundation;
    
    dispatch_once(&onceToken, ^{
        actionGifAVFoundation = [[ActionGifCameraAVFoundation alloc] init];
        actionGifAVFoundation.images = [[NSMutableArray alloc] init];
    });
    return actionGifAVFoundation;
}

+ (void) releaseImages {
    [[self sharedInstance].images removeAllObjects];
}

+ (void) addImage {
    [ActionCameraAVFoundation takePhoto:^(UIImage *image) {
        if (image) {
            [[self sharedInstance].images addObject:image];
        }
    }];
}

+ (void) makeAnimatedGif:(void(^)(NSURL *fileUrl))completionBlock {
    [self sharedInstance].isWorking = true;
    NSUInteger kFrameCount = [self sharedInstance].images.count;
    
    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                         @{(__bridge id)kCGImagePropertyGIFLoopCount: @0}};
    
    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                          @{(__bridge id)kCGImagePropertyGIFDelayTime: DEFAULT_SPEED_GIF,}};
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"animated.gif"];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (UIImage *currentImage in [self sharedInstance].images) {
        @autoreleasepool {
            CGImageDestinationAddImage(destination, currentImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    NSLog(@"url=%@", fileURL);
    [self sharedInstance].isWorking = false;
    completionBlock(fileURL);
}

@end
