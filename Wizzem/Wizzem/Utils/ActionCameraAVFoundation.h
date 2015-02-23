//
//  ActionCameraAVFoundation.h
//  Wizzem
//
//  Created by Remi Robert on 23/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraAVFoundation.h"
#import <ImageIO/CGImageProperties.h>

@interface ActionCameraAVFoundation : NSObject

+ (void) takePhoto:(void(^)(UIImage *))blockCompletion;

@end
