//
//  MediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 21/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <AYVibrantButton.h>
#import "Header.h"
#import "MediaViewController.h"
#import "WizzMedia.h"
#import "DropDown.h"
#import "Colors.h"
#import "SliderCameraFunction.h"
#import "DetailMediaViewController.h"
#import "Wizzem-Swift.h"

@interface MediaViewController ()
@property (nonatomic, strong) UIView *previewCamera;
@property (strong, nonatomic) IBOutlet DropDown *dropDownCameraOptions;
@property (strong, nonatomic) IBOutlet UIView *cameraOptionToolBar;
@property (strong, nonatomic) IBOutlet UIView *cameraPreview;
@property (nonatomic, assign) CGFloat sizeBotton;
@property (nonatomic, strong) TransitionDetailMediaManager *transitionManager;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) SliderCameraFunction *slider;
@property (nonatomic, assign) WizzMediaType currentMediaType;
@end

@implementation MediaViewController

#pragma mark -
#pragma mark Action

- (IBAction)rotateCamera:(id)sender {
    [WizzMedia switchDeviceCamera];
}

- (IBAction)momentAction:(id)sender {
}

- (void)takeMedia {
    switch (self.currentMediaType) {
        case WizzMediaPhoto: {
            [WizzMedia capturePhoto:^(UIImage *image) {
                [self performSegueWithIdentifier:@"detailTransitionController" sender:self];
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark lazy init

- (UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.sizeBotton, self.view.frame.size.width, self.sizeBotton)];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc] initWithEffect:blur];
        
        visualEffect.frame = CGRectMake(0, 0, self.panelView.frame.size.width, self.panelView.frame.size.height);
        
        [_panelView addSubview:visualEffect];
        
        self.cameraOptionToolBar.backgroundColor = [UIColor whiteColor];        
        [self.panelView addSubview:self.slider];
        [self.panelView addSubview:self.dropDownCameraOptions];
    }
    return _panelView;
}

- (DropDown *)dropDownCameraOptions {
    if (!_dropDownCameraOptions) {
        CGRect frameDropDown = CGRectMake(0, 0, self.view.frame.size.width, 50);
        self.dropDownCameraOptions = [[DropDown alloc] initWithFrame:frameDropDown
                                                         contentMenu:@[@"Photo", @"Video", @"Gif", @"Son", @"Text"]
                                                    blockClickButton:^(NSInteger index) {
        }];
    }
    return _dropDownCameraOptions;
}

- (SliderCameraFunction *)slider {
    if (!_slider) {
        _slider = [[SliderCameraFunction alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.height, self.sizeBotton - 50)
                                         blockSelectionButton:^(WizzMediaType mediaType) {
                                             self.currentMediaType = mediaType;
        }];
        for (UIButton *currentButton in _slider.buttons) {
            [currentButton addTarget:self action:@selector(takeMedia) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _slider;
}

#pragma mark -
#pragma mark UIView cycle

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailTransitionController"]) {
        
    }
}

- (void)viewDidLayoutSubviews {
    self.sizeBotton = self.view.frame.size.height - (self.cameraPreview.frame.origin.y + self.cameraPreview.frame.size.height);
    self.cameraOptionToolBar.tag = 6;
    
    
    if (self.panelView.superview == nil) {
        [self.view addSubview:self.panelView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewCamera = [WizzMedia previewCamera:[UIScreen mainScreen].bounds.size];
    [self.view addSubview:self.previewCamera];
    self.view.backgroundColor = [Colors grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
