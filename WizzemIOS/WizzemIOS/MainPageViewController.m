//
//  MainPageViewController.m
//  Wizzem
//
//  Created by Remi Robert on 02/07/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "MainPageViewController.h"
#import "SocialTabBarViewController.h"
#import "CameraViewController.h"
#import "PageViewController.h"

@interface MainPageViewController () <UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *controllers;
@end

@implementation MainPageViewController

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return self.controllers.firstObject;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return self.controllers.lastObject;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    }
    return _pageViewController;
}

- (void)initControllers {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.controllers = @[(SocialTabBarViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"SocialTabBarViewController"],
                         (CameraViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CameraViewController"]];
    
    [self.pageViewController setViewControllers:@[[self.controllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    ((PageViewController *)[self.controllers firstObject]).indexPage = 0;
    ((PageViewController *)[self.controllers firstObject]).indexPage = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControllers];
    
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    self.pageViewController.view.frame = [UIScreen mainScreen].bounds;
    [self.pageViewController didMoveToParentViewController:self];
}

@end
