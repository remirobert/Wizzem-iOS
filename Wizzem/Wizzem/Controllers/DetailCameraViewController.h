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

- (void) initMovieView:(NSURL *)url;

@property (nonatomic, assign) CAMERA_KIND cameraKind;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *gif;
@property (nonatomic, strong) NSURL *urlMovie;
@end
