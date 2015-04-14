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
@end

@implementation MenuMediaViewController

- (IBAction)actionMenu:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *controller;
    if (sender.tag == 1) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"photoController"];
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
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissMenuController:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.transitionManager = [[TransitionMenuMediaManager alloc] init];
    self.transitioningDelegate = self.transitionManager;
    
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.frame = CGRectMake(self.view.frame.size.width / 2 - 20, self.view.frame.size.height / 2 - 50, 40, 40);
//    [closeButton setImage:[[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    [closeButton addTarget:self action:@selector(dismissMenuController:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.tintColor = [UIColor grayColor];
//    [self.view addSubview:closeButton];
}

@end
