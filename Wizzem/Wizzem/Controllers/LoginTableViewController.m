//
//  LoginTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 26/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginTableViewController.h"

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
    [PFUser logInWithUsernameInBackground:self.email.text password:self.password.text block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"ok login connection : %@ %@", user.username, user.email);
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
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
