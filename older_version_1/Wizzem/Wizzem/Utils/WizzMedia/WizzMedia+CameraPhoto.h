//
//  WizzMedia+CameraPhoto.h
//  ExampleWizzMediaFramework
//
//  Created by Remi Robert on 17/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzMedia.h"

@interface WizzMedia (CameraPhoto)

- (void) takePhoto:(void(^)(UIImage *))blockCompletion videoCaptureConnection:(AVCaptureConnection *)connection andSizeContent:(CGSize)size;
- (UIImage*) rotate:(UIImage*)image withOrientation:(UIDeviceOrientation)orientation;

+ (UIImage*) cropImage:(UIImage*)img WithRect:(CGRect)rect;
+ (UIImage *) resizeImage:(UIImage *)image;

@end
