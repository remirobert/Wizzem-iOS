//
//  WizzMedia+CameraPhoto.m
//  ExampleWizzMediaFramework
//
//  Created by Remi Robert on 17/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzMedia+CameraPhoto.h"

@implementation WizzMedia (CameraPhoto)

# pragma mark - resize and crop image

+ (UIImage*) cropImage:(UIImage*)img WithRect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [img drawInRect:drawRect];
    
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

+ (UIImage *) resizeImage:(UIImage *)image {
    CGFloat width = CGImageGetWidth(image.CGImage) / 2.0;
    CGFloat height = CGImageGetHeight(image.CGImage) / 2.0;
    CGFloat bitsPerComponent = CGImageGetBitsPerComponent(image.CGImage);
    CGFloat bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image.CGImage);
    
    CGContextRef context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    UIImage *scaledImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    return scaledImage;
}

#pragma mark - fix orientation image

- (UIImage *) fixOrientationOfImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *) imageRotated:(UIImage*)oldImage byDegrees:(CGFloat)degrees {
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*) rotate:(UIImage*)image withOrientation:(UIDeviceOrientation)orientation {
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            return [self imageRotated:image byDegrees:-90];

        case UIDeviceOrientationLandscapeRight:
            return [self imageRotated:image byDegrees:90];
            
        case UIDeviceOrientationPortraitUpsideDown:
            return [self imageRotated:image byDegrees:180];
            
        default:
            break;
    }
    return image;
}

#pragma mark - take photo

- (void) takePhoto:(void(^)(UIImage *))blockCompletion videoCaptureConnection:(AVCaptureConnection *)connection andSizeContent:(CGSize)size {
    if (TARGET_IPHONE_SIMULATOR) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"image_default_simulator" ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        blockCompletion(image);
        return;
    }
    
    if (connection == nil) {
        blockCompletion(nil);
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            image = [WizzMedia cropImage:image WithRect:CGRectMake(((image.size.width - image.size.width) / 2),
                                                                   ((image.size.height - image.size.width) / 2), image.size.width, image.size.width)];
            blockCompletion([self fixOrientationOfImage:image]);
        }
        else {
            blockCompletion(nil);
        }
    }];
}

@end
