//
//  TabBarViewController.m
//  Wizzem
//
//  Created by Remi Robert on 29/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "TabBarViewController.h"
#import "MenuMediaViewController.h"
#import "Header.h"

@interface TabBarViewController ()
@property (nonatomic, strong) UIAlertController *actionMenu;
@end

@implementation TabBarViewController

- (UIAlertController *)actionMenu {
    if (!_actionMenu) {
        _actionMenu = [UIAlertController alertControllerWithTitle:@"select your media" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        __block UIViewController *controller;
        
        [_actionMenu addAction:[UIAlertAction actionWithTitle:@"Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            controller = [storyboard instantiateViewControllerWithIdentifier:@"photoController"];
            [self presentViewController:controller animated:false completion:nil];
        }]];
        [_actionMenu addAction:[UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            controller = [storyboard instantiateViewControllerWithIdentifier:@"videoController"];
            [self presentViewController:controller animated:false completion:nil];
        }]];
        [_actionMenu addAction:[UIAlertAction actionWithTitle:@"Gif" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            controller = [storyboard instantiateViewControllerWithIdentifier:@"gifController"];
            [self presentViewController:controller animated:false completion:nil];
        }]];
        [_actionMenu addAction:[UIAlertAction actionWithTitle:@"Song" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            controller = [storyboard instantiateViewControllerWithIdentifier:@"songController"];
            [self presentViewController:controller animated:false completion:nil];
        }]];
        [_actionMenu addAction:[UIAlertAction actionWithTitle:@"Text" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            controller = [storyboard instantiateViewControllerWithIdentifier:@"textController"];
            [self presentViewController:controller animated:false completion:nil];
        }]];
        [_actionMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _actionMenu;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)displayMenuController {
    [self presentViewController:self.actionMenu animated:true completion:nil];
}

- (void)presentController:(NSNotification *)notification {
    UIViewController *controller = [notification.userInfo objectForKey:@"controller"];
    if (controller) {
        [self presentViewController:controller animated:false completion:nil];
    }
}

- (void)addUniqueObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object {
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor redColor];

    [self addUniqueObserver:self selector:@selector(presentController:) name:PRESENT_CONTROLLER_NOTIFICATION object:nil];
    
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

@end
