//
//  PhotoHelper.m
//  Wizzem
//
//  Created by Remi Robert on 15/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "PhotoHelper.h"

@implementation PhotoHelper

+ (UIImage *)compraseImage:(UIImage *)largeImage {
    double compressionRatio = 0.5;
    int resizeAttempts = 4;
    
    NSData * imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
    
    NSLog(@"Starting Size: %lu", (unsigned long)[imgData length]);
    
    //Trying to push it below around about 0.4 meg
    while (resizeAttempts > 0) {
        resizeAttempts -= 1;
        
        NSLog(@"Image was bigger than 400000 Bytes. Resizing.");
        NSLog(@"%i Attempts Remaining",resizeAttempts);
        
        //Increase the compression amount
        compressionRatio = compressionRatio*0.5;
        NSLog(@"compressionRatio %f",compressionRatio);
        //Test size before compression
        NSLog(@"Current Size: %lu",(unsigned long)[imgData length]);
        imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
        
        //Test size after compression
        NSLog(@"New Size: %lu",(unsigned long)[imgData length]);
    }
    
    //Set image by comprssed version
    UIImage *savedImage = [UIImage imageWithData:imgData];
    
    //Check how big the image is now its been compressed and put into the UIImageView
    
    // *** I made Change here, you were again storing it with Highest Resolution ***
    NSData *endData = UIImageJPEGRepresentation(largeImage,compressionRatio);
    NSLog(@"Ending Size: %lu", (unsigned long)[endData length]);
    return savedImage;
}


+ (CGSize) aspectScaledImageSizeForImageView:(UIView *)iv image:(UIImage *)im {
    
    float x,y;
    float a,b;
    x = iv.frame.size.width;
    y = iv.frame.size.height;
    a = im.size.width;
    b = im.size.height;
    
    if ( x == a && y == b ) {           // image fits exactly, no scaling required
        // return iv.frame.size;
    }
    else if ( x > a && y > b ) {         // image fits completely within the imageview frame
        if ( x-a > y-b ) {              // image height is limiting factor, scale by height
            a = y/b * a;
            b = y;
        } else {
            b = x/a * b;                // image width is limiting factor, scale by width
            a = x;
        }
    }
    else if ( x < a && y < b ) {        // image is wider and taller than image view
        if ( a - x > b - y ) {          // height is limiting factor, scale by height
            a = y/b * a;
            b = y;
        } else {                        // width is limiting factor, scale by width
            b = x/a * b;
            a = x;
        }
    }
    else if ( x < a && y > b ) {        // image is wider than view, scale by width
        b = x/a * b;
        a = x;
    }
    else if ( x > a && y < b ) {        // image is taller than view, scale by height
        a = y/b * a;
        b = y;
    }
    else if ( x == a ) {
        a = y/b * a;
        b = y;
    } else if ( y == b ) {
        b = x/a * b;
        a = x;
    }
    return CGSizeMake(a,b);
    
}

+ (UIImage *)fixOrientationOfImage:(UIImage *)image {
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

@end
