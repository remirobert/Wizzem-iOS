//
//  MediaCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 30/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "MediaCaptureViewController.h"

@interface MediaCaptureViewController () <NYTPhotosViewControllerDelegate>

@end

@implementation MediaCaptureViewController

- (void)displayPhoto:(UIImage *)photo {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
    photosViewController.delegate = self;
    [self presentViewController:photosViewController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
