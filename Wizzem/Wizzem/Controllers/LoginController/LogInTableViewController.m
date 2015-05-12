//
//  LogInTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 02/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <SVProgressHUD.h>
#import "LogInTableViewController.h"

@interface LogInTableViewController () <UITextFieldDelegate>

@end

@implementation LogInTableViewController

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:true];
        return false;
    }
    
    return true;
}

- (NSString *)email {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    return ((UITextField *)[cell.contentView viewWithTag:1]).text;
}

- (NSString *)password {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    return ((UITextField *)[cell.contentView viewWithTag:1]).text;
}

- (void)login {
    [self.view endEditing:true];
    NSString *email = [self email];
    NSString *password = [self password];
    
    NSLog(@"connection");
    
    [SVProgressHUD show];
    
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
        
        if (user) {
            NSLog(@"ok login connection : %@ %@", user.username, user.email);
            //            User *newUser = [User instance];
            //            newUser.email = user.email;
            //            newUser.password = user.password;
            //            newUser.username = user.username;
            //            [newUser save];
            
            PFUser *logUser = [PFUser currentUser];
            if ([logUser isAuthenticated]) {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *tabbarController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"tabbarController"];
                
                if (tabbarController) {
                    [self presentViewController:tabbarController animated:true completion:nil];
                }
            }
        }
        else {
            if ([error code] == kPFErrorObjectNotFound) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Email or passwork wrong. Click on Signup button for create an account." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                NSLog(@"object not found");
            }
            else if ([error code] == kPFErrorConnectionFailed) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Internet connection error, check your connection." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
                [alert show];
                NSLog(@"Error connection internet");
            }
        }
    }];
}

- (void)presentMainController {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *tabbarController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"tabbarController"];
    
    if (tabbarController) {
        [self presentViewController:tabbarController animated:true completion:nil];
    }
}

- (void)loginFacebook {
    NSArray *permissions = @[@"email", @"user_about_me"];
    
    [SVProgressHUD show];

    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });

            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            return;
        } else if (user.isNew) {
            
            FBSDKGraphRequest *graph = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:nil HTTPMethod:@"GET"];
            [graph startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                NSString *facebookID = result[@"id"];
                NSString *nameF = result[@"first_name"];
                NSString *nameL = result[@"last_name"];
                NSString *email = result[@"email"];
                
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
                //UIImage *fbImage = [UIImage imageWithData:imageData];
                
                NSLog(@"user n : %@", nameF);
                NSLog(@"user n : %@", nameL);
                NSLog(@"email : %@", email);
                
                PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imageData];
                PFUser *user = [PFUser currentUser];
                user[@"email"] = email;
                user[@"first_name"] = nameF;
                user[@"last_name"] = nameL;
                user[@"picture"] = imageFile;
                user[@"true_username"] = [NSString stringWithFormat:@"%@ %@", nameF, nameL];
                user[@"username"] = email;
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    });

                    if (!error) {
                        [self presentMainController];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                    }
                }];
                
            }];
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
            [self presentMainController];
            NSLog(@"User logged in through Facebook!");
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view endEditing:true];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self loginFacebook];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        [self login];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"logoNav"];
        imageView.layer.masksToBounds = true;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(self.view.frame.size.width / 2 - 100 / 2, 10, 200 / 2, 158 / 2);
        imageView.tintColor = [UIColor darkGrayColor];
        
        UIView *container = [UIView new];
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
        [container addSubview:imageView];
        return container;
    }
    if (section == 2) {
        UILabel *lab = [UILabel new];
        lab.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        lab.text = @"- or -";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor lightGrayColor];
        
        
        UIView *container = [UIView new];
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        [container addSubview:lab];
        return container;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 150;
    }
    return 44;
}

@end
