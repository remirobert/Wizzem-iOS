//
//  MediaCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 30/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "MediaCaptureViewController.h"
#import "DetailViewController.h"
#import "Colors.h"

@interface MediaCaptureViewController ()
@end

@implementation MediaCaptureViewController

#pragma mark -
#pragma mark setter getter

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _navigationBar.backgroundColor = [Colors greenColor];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(10, 10, 40, 40);
        [closeButton setImage:[[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        closeButton.tintColor = [Colors grayColor];
        [closeButton addTarget:self action:@selector(dismissMediaController) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:closeButton];
    }
    return _navigationBar;
}

#pragma mark -
#pragma mark Media event management

- (void)displayMedia {
    [self performSegueWithIdentifier:@"detailController" sender:nil];
}

- (void)dismissMediaController {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark -
#pragma mark segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailController"]) {
        ((DetailViewController *)segue.destinationViewController).media = self.currentMedia;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Colors grayColor];
    
    [[self navigationController] setNavigationBarHidden:YES animated:false];
    
    [self.view addSubview:self.navigationBar];
}

@end
