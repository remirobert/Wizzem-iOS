//
//  FollowersTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 12/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import "FollowersTableViewController.h"
#import "ContactList.h"
#import "Friends.h"

@interface FollowersTableViewController ()
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) ContactList *contactList;
@end

@implementation FollowersTableViewController


- (void)loadFriends {
    [SVProgressHUD show];
    
    [PFCloud callFunctionInBackground:@"UserGetFollowed" withParameters:@{@"userHim":[PFUser currentUser].objectId} block:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else {
            NSLog(@"get request : %@", object);
            self.contactList = [[ContactList alloc] initWithUsers:object];
            
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFriends];
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
    
    return cell;
}
@end
