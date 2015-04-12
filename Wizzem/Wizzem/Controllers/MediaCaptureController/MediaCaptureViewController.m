//
//  MediaCaptureViewController.m
//  Wizzem
//
//  Created by Remi Robert on 30/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "MediaCaptureViewController.h"
#import "DetailViewController.h"

@interface MediaCaptureViewController ()
@end

@implementation MediaCaptureViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.2 alpha:1];
}

@end
