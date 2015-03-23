//
//  DetailMediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 22/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "DetailMediaViewController.h"
#import "Wizzem-Swift.h"
#import "Colors.h"
#import "Header.h"
#import "WizzMedia.h"

@interface DetailMediaViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DetailMediaViewController

#pragma mark -
#pragma mark lazy init Preview media

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.image = [self.mediaModel photo];
    }
    return _imageView;
}

#pragma mark -
#pragma mark view cycle

- (void)viewDidLayoutSubviews {
    switch (self.mediaModel.mediaType) {
        case WizzMediaPhoto:
            [self.view addSubview:self.imageView];
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
