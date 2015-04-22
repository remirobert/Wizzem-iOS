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
@property (strong, nonatomic) IBOutlet UIButton *buttonGif;
@end

@implementation MenuMediaViewController

- (IBAction)actionMenu:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *controller;
    if (sender.tag == 1) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"photoController"];
    }
    else if (sender.tag == 2) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"gifController"];
    }
    else if (sender.tag == 3) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"videoController"];
    }
    else if (sender.tag == 4) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"songController"];
    }
    else if (sender.tag == 5) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"textController"];
    }
    
    if (controller) {
        [self dismissViewControllerAnimated:true completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_CONTROLLER_NOTIFICATION object:nil userInfo:@{@"controller":controller}];
        }];
    }
}

- (IBAction)dismissMenuController:(id)sender {
    //animation
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.alpha = 0;
//    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:false completion:nil];
//    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissMenuController:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [self.buttonPhoto setImage:[[UIImage imageNamed:@"photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonPhoto.tintColor = [Colors greenColor];

    
    [self.buttonVideo setImage:[[UIImage imageNamed:@"video"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonVideo.tintColor = [UIColor colorWithRed:0.99 green:0.24 blue:0.22 alpha:1];

    [self.buttonAudio setImage:[[UIImage imageNamed:@"song"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonAudio.tintColor = [UIColor colorWithRed:1 green:0.77 blue:0.01 alpha:1];

    [self.buttonGif setImage:[[UIImage imageNamed:@"gif"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonGif.tintColor = [UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1];
    
    [self.buttonText setImage:[[UIImage imageNamed:@"text"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.buttonText.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
}

@end
