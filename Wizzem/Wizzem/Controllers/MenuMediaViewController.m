//
//  MenuMediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 29/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "MenuMediaViewController.h"
#import "Wizzem-Swift.h"
#import <FBShimmeringView.h>
#import "Colors.h"
#import "Header.h"

@interface MenuMediaViewController ()
@property (nonatomic, strong) TransitionMenuMediaManager *transitionManager;
@property (strong, nonatomic) IBOutlet UIButton *buttonPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonVideo;
@property (strong, nonatomic) IBOutlet UIButton *buttonAudio;
@property (strong, nonatomic) IBOutlet UIButton *buttonText;
@end

@implementation MenuMediaViewController

- (IBAction)actionMenu:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *controller;
    if (sender.tag == 1) {
//        controller = [storyboard instantiateViewControllerWithIdentifier:@"photoController"];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"gifController"];
    }
    else if (sender.tag == 2) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"videoController"];
    }
    else if (sender.tag == 3) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"songController"];
    }
    else if (sender.tag == 4) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"textController"];
    }
    
    if (controller) {
        [self dismissViewControllerAnimated:true completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_CONTROLLER_NOTIFICATION object:nil userInfo:@{@"controller":controller}];
        }];
    }
}

- (IBAction)dismissMenuController:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissMenuController:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.view.alpha = 0;
//    self.transitionManager = [[TransitionMenuMediaManager alloc] init];
//    self.transitioningDelegate = self.transitionManager;
    
    [self.buttonPhoto setImage:[[UIImage imageNamed:@"photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonPhoto.tintColor = [Colors greenColor];

    
    [self.buttonVideo setImage:[[UIImage imageNamed:@"video"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonVideo.tintColor = [UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:1];

    [self.buttonAudio setImage:[[UIImage imageNamed:@"song"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonAudio.tintColor = [UIColor colorWithRed:1 green:0.77 blue:0.01 alpha:1];


    [self.buttonText setImage:[[UIImage imageNamed:@"text"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonText.tintColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.83 alpha:1];

//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.frame = CGRectMake(self.view.frame.size.width / 2 - 20, self.view.frame.size.height / 2 - 50, 40, 40);
//    [closeButton setImage:[[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    [closeButton addTarget:self action:@selector(dismissMenuController:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.tintColor = [UIColor grayColor];
//    [self.view addSubview:closeButton];
}

@end
