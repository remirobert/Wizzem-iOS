
//
//  SelectFriendsTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 04/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import "Friends.h"
#import "ContactList.h"
#import "SelectFriendsTableViewController.h"

@interface SelectFriendsTableViewController ()
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) PFQuery *query;
@property (nonatomic, strong) NSString *currentSearch;
@property (nonatomic, strong) NSArray *currentFriends;
@property (nonatomic, strong) PFUser *selectedUser;
@property (nonatomic, strong) ContactList *contactList;
@end

@implementation SelectFriendsTableViewController

- (NSMutableArray *)selectedUsers {
    if (!_selectedUsers) {
        _selectedUsers = [NSMutableArray array];
    }
    return _selectedUsers;
}

- (IBAction)dismissController:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)loadFriends {
    [SVProgressHUD show];
    
    [PFCloud callFunctionInBackground:@"UserGetFollowing" withParameters:@{@"userHim":[PFUser currentUser].objectId} block:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else {
            self.contactList = [[ContactList alloc] initWithUsers:object];
            
            NSLog(@"get request : %@", object);
            [self.tableView reloadData];
            Friends *newList = [Friends new];
            
            for (PFUser *currentUser in object) {
                [newList addFriend:currentUser[@"true_username"] withEmail:currentUser.email];
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFriends];
}

- (void)selectUsersCompletion {
    NSLog(@"%@", self.blockCompletion);
    if (self.blockCompletion) {
        self.blockCompletion(self.selectedUsers);
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactList.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.contactList.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.contactList.sections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactList countObjectsForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    
    cell.textLabel.text = ((PFUser *)[self.contactList objectForSection:indexPath.section inRow:indexPath.row]).username;
    
    NSString *username = cell.textLabel.text;
    if ([self.selectedUsers containsObject:username]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *username = cell.textLabel.text;
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([self.selectedUsers containsObject:username]) {
        [self.selectedUsers removeObject:username];
        if (self.selectedUsers.count == 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"select" style:UIBarButtonItemStyleDone target:self action:@selector(selectUsersCompletion)];
        [self.selectedUsers addObject:username];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
