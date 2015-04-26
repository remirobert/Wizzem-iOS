//
//  ProfileViewController.m
//  Wizzem
//
//  Created by Remi Robert on 26/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UILabel *login;
@end

@implementation ProfileViewController

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *PF_NULLABLE_S error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error logout" message:@"Try again" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *loginController = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginController"];
            if (loginController) {
                [self presentViewController:loginController animated:true completion:nil];
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.login.text = [PFUser currentUser].username;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
