//
//  MediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 21/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "MediaViewController.h"
#import "WizzMedia.h"
#import "DropDown.h"
#import "Colors.h"
#import "SliderCameraFunction.h"
#import "DetailMediaViewController.h"
#import "Wizzem-Swift.h"
#import <AYVibrantButton.h>

@interface MediaViewController ()
@property (nonatomic, strong) UIView *previewCamera;
@property (strong, nonatomic) IBOutlet DropDown *dropDownCameraOptions;
@property (strong, nonatomic) IBOutlet UIView *cameraOptionToolBar;
@property (strong, nonatomic) IBOutlet UIView *cameraPreview;
@property (nonatomic, assign) CGFloat sizeBotton;
@property (nonatomic, strong) TransitionDetailMediaManager *transitionManager;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) SliderCameraFunction *slider;
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
    
    [WizzMedia capturePhoto:^(UIImage *image) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailMediaViewController *detailController;
        if (mainStoryBoard && (detailController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"detailMediaController"])) {
            [detailController addMedia:image];
            detailController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            //[self.navigationController pushViewController:detailController animated:true];
            [self presentViewController:detailController animated:true completion:nil];
        }
    }];
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
        
        UIBlurEffect *Lightblur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectToolBar = [[UIVisualEffectView alloc] initWithEffect:Lightblur];
        
        
        visualEffectToolBar.frame = CGRectMake(0, 0, self.cameraOptionToolBar.frame.size.width, self.cameraOptionToolBar.frame.size.height);
        
        [self.cameraOptionToolBar addSubview:visualEffectToolBar];

        
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
        _slider = [[SliderCameraFunction alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.height, self.sizeBotton - 50)];
    }
    return _slider;
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewDidAppear:(BOOL)animated {
    
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
    
    
    
    //preview.tag = 5;
//    self.transitionManager = [[TransitionDetailMediaManager alloc] init];
//    self.transitioningDelegate = self.transitionManager;
    self.view.backgroundColor = [Colors grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
