//
//  PhotoHelper.h
//  Wizzem
//
//  Created by Remi Robert on 15/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PhotoHelper : NSObject

+ (UIImage *)fixOrientationOfImage:(UIImage *)image;

@end