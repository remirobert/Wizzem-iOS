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

@interface MediaViewController ()
@property (strong, nonatomic) IBOutlet DropDown *dropDownCameraOptions;
@property (strong, nonatomic) IBOutlet UIView *cameraOptionToolBar;
@property (strong, nonatomic) IBOutlet UIView *cameraPreview;
@property (nonatomic, assign) CGFloat sizeBotton;
@property (nonatomic, strong) TransitionDetailMediaManager *transitionManager;
@end

@implementation MediaViewController

#pragma mark -
#pragma mark Action

- (IBAction)rotateCamera:(id)sender {
    [WizzMedia switchDeviceCamera];
}

- (IBAction)momentAction:(id)sender {
}

- (IBAction)flashCamera:(id)sender {
}

- (void)takeMedia {
    
    [WizzMedia capturePhoto:^(UIImage *image) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailMediaViewController *detailController;
        if (mainStoryBoard && (detailController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"detailMediaController"])) {
            [detailController addMedia:image];
            detailController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:detailController animated:true completion:nil];
        }
    }];
}

#pragma mark -
#pragma mark UIView cycle

- (void)viewDidAppear:(BOOL)animated {
    
//    SliderCameraFunction *slider = [[SliderCameraFunction alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.sizeBotton, self.view.frame.size.height, self.sizeBotton)];
//    [self.view addSubview:slider];
    CGFloat sizeButton = self.sizeBotton - self.sizeBotton / 3;
    CGRect frameButton = CGRectMake(self.view.center.x - sizeButton / 2, self.view.frame.size.height - sizeButton - sizeButton / 2, sizeButton, sizeButton);
    
    frameButton.origin.y = self.view.frame.size.height - self.sizeBotton + (self.sizeBotton - sizeButton) / 2;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frameButton;
    [button setImage:[[UIImage imageNamed:@"captureButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.tintColor = [Colors greenColor];
    [button addTarget:self action:@selector(takeMedia) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGRect frameDropDown = CGRectMake(0, self.view.frame.size.height - self.sizeBotton - 50, self.view.frame.size.width, 50);
    
    self.dropDownCameraOptions = [[DropDown alloc] initWithFrame:frameDropDown contentMenu:@[@"Photo", @"Video", @"Gif", @"Son", @"Text"] blockClickButton:^(NSInteger index) {
        
    }];
    [self.view addSubview:self.dropDownCameraOptions];
}

- (void)viewDidLayoutSubviews {
    self.sizeBotton = self.view.frame.size.height - (self.cameraPreview.frame.origin.y + self.cameraPreview.frame.size.height + 50);
    UIView *preview = [WizzMedia previewCamera:self.cameraPreview.frame.size];
    preview.tag = 5;
    self.cameraOptionToolBar.tag = 6;
    [self.cameraPreview addSubview:preview];
    [preview addSubview:[self.cameraPreview viewWithTag:1]];
    [preview addSubview:[self.cameraPreview viewWithTag:2]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.transitionManager = [[TransitionDetailMediaManager alloc] init];
//    self.transitioningDelegate = self.transitionManager;
    self.view.backgroundColor = [Colors grayColor];
    self.cameraOptionToolBar.backgroundColor = [Colors greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
