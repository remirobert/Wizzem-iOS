//
//  LoginTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 26/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import <SVProgressHUD.h>
#import "LoginTableViewController.h"
#import "User.h"
#import "PFObject+NSCoding.h"

@interface LoginTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@end

@implementation LoginTableViewController

#pragma mark -
#pragma mark UItextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:true];
    }
    return true;
}

#pragma mark -
#pragma mark Action

- (IBAction)connection:(id)sender {
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

#pragma mark -
#pragma mark UITableView cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    User *user = [User restaure];
    if (user) {
        self.email.text = user.email;
        self.password.text = user.password;
    }
}

@end