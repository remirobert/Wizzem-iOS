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

- (void)viewDidAppear:(BOOL)animated {
    [SVProgressHUD show];
    PFRelation *relation = [[PFUser currentUser] objectForKey:@"friends"];
    PFQuery *query = [relation query];
    self.currentFriends = [query findObjects];
    
    NSLog(@"friends : %@", self.currentFriends);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)searchUser:(NSString *)string {
    [self.query cancel];
    
    if ([string containsString:@"@"]) {
        [self.query whereKey:@"email" equalTo:[string lowercaseString]];
    }
    else {
        
        PFQuery *queryCapitalizedString = [PFUser query];
        [queryCapitalizedString whereKey:@"username" containsString:[string capitalizedString]];
        
        PFQuery *queryLowerCaseString = [PFUser query];
        [queryLowerCaseString whereKey:@"username" containsString:[string lowercaseString]];
        
        PFQuery *querySearchBarString = [PFUser query];
        [querySearchBarString whereKey:@"username" containsString:string];
        
        self.query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCapitalizedString,queryLowerCaseString, querySearchBarString,nil]];
    }
    
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.users = [NSMutableArray array];
        
        for (PFUser *currentUser in objects) {
            if (![self.currentFriends containsObject:currentUser] && ![currentUser isEqual:[PFUser currentUser]]) {
                [self.users addObject:currentUser];
            }
        }
        
        self.contactList = [[ContactList alloc] initWithUsers:self.users];
        
        [self.tableView reloadData];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0 && ![self.currentSearch isEqualToString:searchBar.text]) {
        self.currentSearch = searchBar.text;
        [self searchUser:searchBar.text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"pass here : %@", searchBar.text);
    if (searchBar.text.length > 0 && ![self.currentSearch isEqualToString:searchBar.text]) {
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
    
    NSLog(@"current user : %@", [PFUser currentUser].username);
    
    PFRelation *relation = [[PFUser currentUser] objectForKey:@"friends"];
    [relation addObject:user];
    NSLog(@"relations : %@", relation);
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            return;
        }
        if (succeeded) {
            [self.users removeObject:user];
            [self.contactList removeUser:user];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"error add friend");
        }
    }];
}

@end
