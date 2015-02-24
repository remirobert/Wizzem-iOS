//
//  DetailCameraViewController.h
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderButtonPhoto.h"

@interface DetailCameraViewController : UIViewController

@property (nonatomic, assign) CAMERA_KIND cameraKind;
@property (nonatomic, strong) UIImage *image;

@end
