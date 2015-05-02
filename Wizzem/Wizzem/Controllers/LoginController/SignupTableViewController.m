//
//  SignupTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 02/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "SignupTableViewController.h"

@interface SignupTableViewController () <UITextFieldDelegate>

@end

@implementation SignupTableViewController

- (void)signup {
    [self.view endEditing:true];
    NSString *username = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].contentView viewWithTag:1]).text;
    NSString *email = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].contentView viewWithTag:1]).text;

    NSString *password = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]].contentView viewWithTag:1]).text;
    NSString *passwordConfirmation = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]].contentView viewWithTag:1]).text;
    
    if (username && email && [password isEqualToString:passwordConfirmation]) {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.email = email;
        newUser.password = password;
        
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:true];
        return false;
    }
    
    return true;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view endEditing:true];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;

    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self signup];
    }
}

@end
