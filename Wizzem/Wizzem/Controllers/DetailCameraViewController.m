//
//  DetailCameraViewController.m
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "DetailCameraViewController.h"

@interface DetailCameraViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DetailCameraViewController

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void) initImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.image = self.image;
    
    [self.view addSubview:self.imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.cameraKind == PHOTO_CAMERA) {
        [self initImageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
