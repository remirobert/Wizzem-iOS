//
//  ProfileViewController.m
//  Wizzem
//
//  Created by Remi Robert on 26/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageProfile;
@property (nonatomic, strong) UILabel *numberFollowers;
@property (nonatomic, strong) UILabel *numberFollowing;
@end

@implementation ProfileViewController

- (UIImageView *)imageProfile {
    if (!_imageProfile) {
        _imageProfile = [[UIImageView alloc] init];
        _imageProfile.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width / 3);
        _imageProfile.layer.cornerRadius = [UIScreen mainScreen].bounds.size.width / 3 / 2;
        
        PFFile *picture = [PFUser currentUser][@"picture"];
        [picture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data && !error) {
                _imageProfile.image = [UIImage imageWithData:data];
            }
        }];
    }
    return _imageProfile;
}

//- (IBAction)logout:(id)sender {
//    [SVProgressHUD show];
//    
//    [PFUser logOutInBackgroundWithBlock:^(NSError *PF_NULLABLE_S error) {
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
//        });
//        
//        if (error) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error logout" message:@"Try again" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alert show];
//        }
//        else {
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIViewController *loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginController"];
//            if (loginController) {
//                [self presentViewController:loginController animated:true completion:nil];
//            }
//        }
//    }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [PFCloud callFunctionInBackground:@"FriendCountFollowing" withParameters:@{@"userHim":[PFUser currentUser].objectId} block:^(id object, NSError *error) {
        if (!error) {
            self.numberFollowing.text = [NSString stringWithFormat:@"%@", object];
        }
    }];
    [PFCloud callFunctionInBackground:@"FriendCountFollowers" withParameters:@{@"userHim":[PFUser currentUser].objectId} block:^(id object, NSError *error) {
        if (!error) {
            self.numberFollowers.text = [NSString stringWithFormat:@"%@", object];
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *container = [[UIView alloc] init];
    
    if (section == 0) {
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
        container.backgroundColor = [UIColor clearColor];
        
        UIView *imageContainer = [[UIView alloc] init];
        imageContainer.frame = CGRectMake(self.view.frame.size.width / 2 - ([UIScreen mainScreen].bounds.size.width / 3 / 2), 20, [UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width / 3);
        imageContainer.layer.masksToBounds = true;
        imageContainer.layer.cornerRadius = [UIScreen mainScreen].bounds.size.width / 3 / 2;
        [imageContainer addSubview:self.imageProfile];
        
        UILabel *username = [[UILabel alloc] init];
        username.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width / 3 + 40, self.view.frame.size.width, 30);
        username.text = [PFUser currentUser][@"true_username"];
        username.font = [UIFont boldSystemFontOfSize:20];
        username.textAlignment = NSTextAlignmentCenter;
        [username sizeToFit];
        username.frame = CGRectMake(self.view.frame.size.width / 2 - username.frame.size.width / 2, username.frame.origin.y, username.frame.size.width, username.frame.size.height);
        
        UIButton *buttonSettings = [[UIButton alloc] init];
        [buttonSettings setImage:[[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        buttonSettings.tintColor = [UIColor grayColor];
        buttonSettings.frame = CGRectMake(username.frame.origin.x + username.frame.size.width + 10, username.frame.origin.y, username.frame.size.height, username.frame.size.height);

        UIButton *followers = [[UIButton alloc] init];
        followers.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 3 / 2 - 50, 20 + [UIScreen mainScreen].bounds.size.width / 3 / 2, 100, 100);
        
        self.numberFollowers = [[UILabel alloc] init];
        self.numberFollowers.frame = CGRectMake(0, 0, 100, 20);
        self.numberFollowers.textAlignment = NSTextAlignmentCenter;
        self.numberFollowers.text = @"0";
        self.numberFollowers.font = [UIFont boldSystemFontOfSize:22];
        
        UILabel *labelTitleFollowers = [[UILabel alloc] init];
        labelTitleFollowers.frame = CGRectMake(0, 20, 100, 20);
        labelTitleFollowers.textAlignment = NSTextAlignmentCenter;
        labelTitleFollowers.text = @"Followers";
        labelTitleFollowers.textColor = [UIColor lightGrayColor];
        [followers addSubview:self.numberFollowers];
        [followers addSubview:labelTitleFollowers];
        
        
        UIButton *following = [[UIButton alloc] init];
        following.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 3 * 2) + ([UIScreen mainScreen].bounds.size.width / 3 / 2 - 50), 20 + [UIScreen mainScreen].bounds.size.width / 3 / 2, 100, 30);

        self.numberFollowing = [[UILabel alloc] init];
        self.numberFollowing.frame = CGRectMake(0, 0, 100, 20);
        self.numberFollowing.textAlignment = NSTextAlignmentCenter;
        self.numberFollowing.text = @"0";
        self.numberFollowing.font = [UIFont boldSystemFontOfSize:22];
        
        UILabel *labelTitleFollowing = [[UILabel alloc] init];
        labelTitleFollowing.frame = CGRectMake(0, 20, 100, 20);
        labelTitleFollowing.textAlignment = NSTextAlignmentCenter;
        labelTitleFollowing.text = @"Following";
        labelTitleFollowing.textColor = [UIColor lightGrayColor];
        [following addSubview:self.numberFollowing];
        [following addSubview:labelTitleFollowing];
        
        [container addSubview:imageContainer];
        [container addSubview:followers];
        [container addSubview:following];
        [container addSubview:username];
    }
    else {
        container.backgroundColor = [UIColor whiteColor];
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Passé", @"En cours", @"A venir"]];
        segment.selectedSegmentIndex = 1;
        segment.selected = true;
        segment.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, 30);
        
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, segment.frame.size.height + 20);
        
        [container addSubview:segment];
    }
    return container;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 300;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"test";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
