//
//  SignupViewController.m
//  Wizzem
//
//  Created by Remi Robert on 28/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "SignupViewController.h"

@interface SignupViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *passwordChecked;
@end

@implementation SignupViewController

#pragma mark -
#pragma mark UItextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:true];
    }
    return true;
}

- (IBAction)signup:(id)sender {
    if (self.email.text && [self.password.text isEqualToString:self.passwordChecked.text]) {
        PFUser *newUser = [PFUser user];
        newUser.username = self.email.text;
        newUser.email = self.email.text;
        newUser.password = self.password.text;
        
        [SVProgressHUD show];
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
            
            if (succeeded) {
                
                NSLog(@"Your are signup good game");
                
                if ([[PFUser currentUser] isAuthenticated]) {
                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *tabbarController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"tabbarController"];
                    
                    if (tabbarController) {
                        [self presentViewController:tabbarController animated:true completion:nil];
                    }
                }
                
            }
            if (error) {
                NSLog(@"error : %@", error);
            }
        }];
    }
}

- (IBAction)signupFacebook:(id)sender {
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
    self.passwordChecked.delegate = self;
}

@end
