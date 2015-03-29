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
#import "WizzMediaModel.h"
#import "ProgressBar.h"

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
@property (nonatomic, strong) WizzMediaModel *currentModel;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) ProgressBar *progressBar;

@property (nonatomic, strong) NSTimer *timerProgress;
@end

@implementation MediaViewController

#pragma mark -
#pragma mark Action

- (IBAction)rotateCamera:(id)sender {
    [WizzMedia switchDeviceCamera];
}

- (IBAction)momentAction:(id)sender {
}

- (void)addPhoto {
    if (self.photos.count == 15) {
        [self takeMedia];
    }
    [WizzMedia capturePhoto:^(UIImage *image) {
        if (!self.photos) {
            self.photos = [[NSMutableArray alloc] init];
        }
        [self.photos addObject:image];
        if (self.photos.count == 2) {
            
            NSLog(@"superview : %@", self.actionButton.superview);
            
            [self.actionButton bringSubviewToFront:self.view];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
                self.actionButton.frame = CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - self.slider.frame.size.height / 2, 50, 50);
            } completion:nil];
        }
        [self.progressBar setProgress:self.photos.count];
    }];
}

- (void)progressTime {
    NSLog(@"called %d", self.timerProgress.isValid);
    

    [self.progressBar setProgress:self.progressBar.currentValue + 1];
}

- (void)addMovie {
    if (![WizzMedia isRecordingMovie]) {
        [self.progressBar setProgress:0];
        
        self.timerProgress = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressTime) userInfo:nil repeats:true];
        [self.timerProgress fire];
        
        [WizzMedia startRecordMovie:^(NSURL *movie) {
            self.currentModel = [[WizzMediaModel alloc] init:WizzMediaVideo genericObjectMedia:movie];
            [self performSegueWithIdentifier:@"detailTransitionController" sender:self];
        }];
    }
    else {
        [self.timerProgress invalidate];
        self.timerProgress = nil;
        [WizzMedia stopRecordingMovie];
    }
}

- (void)takeMedia {
    NSLog(@"take media");
    switch (self.currentMediaType) {
        case WizzMediaPhoto: {
            NSLog(@"capture photo");
            [WizzMedia capturePhoto:^(UIImage *image) {
                self.currentModel = [[WizzMediaModel alloc] init:WizzMediaPhoto genericObjectMedia:image];
                [self performSegueWithIdentifier:@"detailTransitionController" sender:self];
            }];
            break;
        }
            
        case WizzMediaGif: {
            NSLog(@"build gif");
            [WizzMedia captureGif:self.photos blockCompletion:^(NSData *gif) {
                self.currentModel = [[WizzMediaModel alloc] init:WizzMediaGif genericObjectMedia:gif];
                [self performSegueWithIdentifier:@"detailTransitionController" sender:self];
            }];
            break;
        }
            
        case WizzMediaVideo: {
            [self addMovie];
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
        
        self.progressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        self.progressBar.maxValue = 15;
        [_panelView addSubview:self.progressBar];
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
                                             if (self.photos) {
                                                 [self.photos removeAllObjects];
                                             }
                                             [UIView animateWithDuration:0.5 animations:^{
                                                 self.actionButton.frame = CGRectMake(self.actionButton.frame.origin.x, self.view.frame.size.height, self.actionButton.frame.size.width, self.actionButton.frame.size.height);
                                             }];
                                             [self.progressBar setProgress:0];
                                             [self.dropDownCameraOptions setIndexDropDownMenu:mediaType];
        }];
        for (UIButton *currentButton in _slider.buttons) {
            if (currentButton.tag == WizzMediaGif) {
                [currentButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                [currentButton addTarget:self action:@selector(takeMedia) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return _slider;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60,
                                                                   self.view.frame.size.height, 50, 50)];
        _actionButton.backgroundColor = [UIColor whiteColor];
        _actionButton.layer.cornerRadius = 25;
        _actionButton.layer.borderWidth = 5;
        _actionButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [_actionButton addTarget:self action:@selector(takeMedia) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

#pragma mark -
#pragma mark UIView cycle

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailTransitionController"]) {
        ((DetailMediaViewController *)segue.destinationViewController).mediaModel = self.currentModel;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.progressBar setProgress:0];
    [self.photos removeAllObjects];
}

- (void)viewDidLayoutSubviews {
    self.sizeBotton = self.view.frame.size.height - (self.cameraPreview.frame.origin.y + self.cameraPreview.frame.size.height);
    self.cameraOptionToolBar.tag = 6;
    
    
    if (!self.panelView.superview) {
        [self.view addSubview:self.panelView];
    }
    if (!self.actionButton.superview) {
        [self.view addSubview:self.actionButton];
        [self.actionButton bringSubviewToFront:self.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentMediaType = WizzMediaPhoto;
    self.previewCamera = [WizzMedia previewCamera:[UIScreen mainScreen].bounds.size];
    [self.view addSubview:self.previewCamera];
    self.view.backgroundColor = [Colors grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
