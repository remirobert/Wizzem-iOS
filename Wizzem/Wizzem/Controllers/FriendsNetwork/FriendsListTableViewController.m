//
//  FriendsListTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import "FriendsListTableViewController.h"
#import "ContactList.h"
#import "Friends.h"

@interface FriendsListTableViewController ()
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) ContactList *contactList;
@end

@implementation FriendsListTableViewController

- (void)loadFriends {
    [SVProgressHUD show];
    PFRelation *relation = [[PFUser currentUser] objectForKey:@"friends"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
//            if (self.refreshControl.refreshing) {
//                [self.refreshControl endRefreshing];
//            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else {
            self.contactList = [[ContactList alloc] initWithUsers:objects];

            NSLog(@"get request");
            [self.tableView reloadData];
            Friends *newList = [Friends new];
            
            for (PFUser *currentUser in objects) {
                [newList addFriend:currentUser.username withEmail:currentUser.email];
            }
            [newList save];
//            if (self.refreshControl.refreshing) {
//                [self.refreshControl endRefreshing];
//            }
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Friends *list = [Friends instance];
    NSLog(@"%@", list.friends);
    if (!list.friends || list.friends.count == 0) {
        [self loadFriends];
    }
    else {
        NSLog(@"get results");
        self.contactList = [[ContactList alloc] initWithUsers:list.friends];
        [self.tableView reloadData];
    }
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
