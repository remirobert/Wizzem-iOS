//
//  LoginViewController.m
//  Wizzem
//
//  Created by Remi Robert on 28/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <SVProgressHUD.h>
#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@end

@implementation LoginViewController

#pragma mark -
#pragma mark UItextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:true];
    }
    return true;
}

- (IBAction)login:(id)sender {
    NSLog(@"connection");
    
    [SVProgressHUD show];
    
    [PFUser logInWithUsernameInBackground:self.email.text password:self.password.text block:^(PFUser *user, NSError *error) {
        
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

- (IBAction)loginFacebook:(id)sender {
    NSLog(@"log with facebook");
    
    NSArray *permissions = @[@"email"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            return;
        } else if (user.isNew) {
            
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *tabbarController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"tabbarController"];
        
        if (tabbarController) {
            [self presentViewController:tabbarController animated:true completion:nil];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.email.text = @"remirobert33530@gmail.com";
    self.password.text = @"remi";
}

@end
