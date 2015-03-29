//
//  TabBarViewController.m
//  Wizzem
//
//  Created by Remi Robert on 29/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "TabBarViewController.h"
#import "MenuMediaViewController.h"

@interface TabBarViewController ()
@end

@implementation TabBarViewController

- (void)displayMenuController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuMediaViewController *menuController;
    if (mainStoryboard && (menuController = [mainStoryboard instantiateViewControllerWithIdentifier:@"menuController"])) {
        menuController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [self presentViewController:menuController animated:true completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor redColor];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, 40, 40);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(displayMenuController) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = 40 - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
