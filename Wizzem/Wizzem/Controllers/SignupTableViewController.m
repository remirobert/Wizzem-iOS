//
//  SignupTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 26/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import "SignupTableViewController.h"

@interface SignupTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *passwordChecked;
@end

@implementation SignupTableViewController

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

- (IBAction)signup:(id)sender {
    if (self.email.text && [self.password.text isEqualToString:self.passwordChecked.text]) {
        PFUser *newUser = [PFUser user];
        newUser.username = ([self.username.text isEqualToString:@""]) ? self.email.text : self.username.text;
        newUser.email = self.email.text;
        newUser.password = self.password.text;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error) {
            if (succeeded) {
                NSLog(@"Your are signup good game");
            }
            if (error) {
                NSLog(@"error : %@", error);
            }
        }];
    }
}

#pragma mark -
#pragma mark UITableView cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
