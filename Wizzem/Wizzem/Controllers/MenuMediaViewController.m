//
//  MenuMediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 29/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "MenuMediaViewController.h"
#import "Wizzem-Swift.h"

@interface MenuMediaViewController ()
@property (nonatomic, strong) TransitionMenuMediaManager *transitionManager;
@end

@implementation MenuMediaViewController

- (IBAction)dismissMenuController:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.transitionManager = [[TransitionMenuMediaManager alloc] init];
    self.transitioningDelegate = self.transitionManager;    
}

@end
