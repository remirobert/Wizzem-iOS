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

@interface DetailMediaViewController ()
@property (nonatomic, strong) TransitionDetailMediaManager *transitionManager;
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic, strong) UIImageView *photoDetailView;
@property (nonatomic, assign) MediaType mediaType;
@end

@implementation DetailMediaViewController

#pragma mark -
#pragma mark Actions

- (IBAction)dismissController:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark -
#pragma mark Lazy init view detail

- (UIImageView *)photoDetailView {
    if (!_photoDetailView) {
        _photoDetailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.previewView.frame.size.width, self.previewView.frame.size.height)];
        _photoDetailView.contentMode = UIViewContentModeScaleAspectFit;
        _photoDetailView.layer.masksToBounds = true;
    }
    return _photoDetailView;
}

#pragma mark -
#pragma mark Manage media

- (void)addMedia:(UIImage *)photo {
    self.mediaType = MediaImage;
    self.photoDetailView.image = photo;
}

#pragma mark -
#pragma mark UIView life cycle

- (void)viewDidLayoutSubviews {
    switch (self.mediaType) {
        case MediaImage:
            self.photoDetailView.frame = CGRectMake(0, 0, self.previewView.frame.size.width, self.previewView.frame.size.height);
            [self.previewView addSubview:self.photoDetailView];
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Colors grayColor];
    self.transitionManager = [[TransitionDetailMediaManager alloc] init];
    self.transitioningDelegate = self.transitionManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
