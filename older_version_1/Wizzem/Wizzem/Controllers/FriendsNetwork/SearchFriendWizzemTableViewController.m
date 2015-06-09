//
//  SearchFriendWizzemTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import "SearchFriendWizzemTableViewController.h"
#import "Friends.h"
#import "ContactList.h"

@interface SearchFriendWizzemTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) PFQuery *query;
@property (nonatomic, strong) NSString *currentSearch;
@property (nonatomic, strong) NSArray *currentFriends;
@property (nonatomic, strong) PFUser *selectedUser;
@property (nonatomic, strong) ContactList *contactList;
@end

@implementation SearchFriendWizzemTableViewController

- (PFQuery *)query {
    if (!_query) {
        _query = [[PFQuery alloc] init];
        _query.limit = 100;
    }
    return _query;
}

- (BOOL)checkUser:(PFUser *)currentUser {
    if ([currentUser.email isEqualToString:[PFUser currentUser].email]) {
        return false;
    }
    for (Friend *friend in self.currentFriends) {
        if ([friend.email isEqualToString:currentUser.email]) {
            return false;
        }
    }
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    Friends *list = [Friends instance];
    self.currentFriends = list.friends;
}

- (void)searchUser:(NSString *)string {
    [self.query cancel];
    
    [PFCloud callFunctionInBackground:@"FriendSearchFollowing" withParameters:@{@"userHim":[PFUser currentUser].objectId, @"search":string} block:^(id object, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else {
            NSLog(@"dico : %@", (NSDictionary *)object);
            self.users = [NSMutableArray array];
            
            for (PFUser *currentUser in object) {
                if ([self checkUser:currentUser]) {
                    [self.users addObject:currentUser];
                }
            }
            
            self.contactList = [[ContactList alloc] initWithUsers:self.users];
            [self.tableView reloadData];
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 3 && ![self.currentSearch isEqualToString:searchBar.text]) {
        self.currentSearch = searchBar.text;
        [self searchUser:searchBar.text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"pass here : %@", searchBar.text);
    if (searchBar.text.length > 3 && ![self.currentSearch isEqualToString:searchBar.text]) {
        self.currentSearch = searchBar.text;
        [self searchUser:searchBar.text];
    }
    [self.view endEditing:true];
}

#pragma mark -
#pragma mark UItableView datasource

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

#pragma mark -
#pragma mark UItableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.selectedUser = [self.contactList objectForSection:indexPath.section inRow:indexPath.row];
    NSString *msg = [NSString stringWithFormat:@"Do you wan to add \"%@\" as friend ?", self.selectedUser.username];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alert show];
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    
    PFUser *user = self.selectedUser;

    [PFCloud callFunctionInBackground:@"FriendAdd" withParameters:@{@"userHim":[PFUser currentUser].objectId, @"userHas":user.objectId} block:^(id object, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        NSLog(@"add friend ok");
        [self.users removeObject:user];
        [self.contactList removeUser:user];
        [self.tableView reloadData];
    }];
}

@end
