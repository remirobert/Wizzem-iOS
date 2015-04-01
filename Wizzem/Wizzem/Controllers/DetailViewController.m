//
//  DetailViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "DetailViewController.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface DetailViewController ()
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@end

@implementation DetailViewController

#pragma mark -
#pragma mark setter getter

- (FLAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                           [UIScreen mainScreen].bounds.size.width)];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (void)displayPhoto {
    self.imageView.image = [self.media photo];
    [self.view addSubview:self.imageView];
}

- (void)displayGif {
    FLAnimatedImage *img = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[self.media gif]];
    self.imageView.animatedImage = img;
    [self.view addSubview:self.imageView];
}

- (void) viewDidLayoutSubviews {
    switch (self.media.mediaType) {
        case WizzMediaPhoto:
            [self displayPhoto];
            break;
            
        case WizzMediaGif:
            [self displayGif];
            break;
            
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
