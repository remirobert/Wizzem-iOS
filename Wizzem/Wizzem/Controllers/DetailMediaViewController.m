//
//  DetailMediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 22/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "DetailMediaViewController.h"
#import "Wizzem-Swift.h"
#import "Colors.h"

@interface DetailMediaViewController ()
@property (nonatomic, strong) TransitionDetailMediaManager *transitionManager;
@end

@implementation DetailMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Colors grayColor];
    self.transitionManager = [[TransitionDetailMediaManager alloc] init];
    self.transitioningDelegate = self.transitionManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
