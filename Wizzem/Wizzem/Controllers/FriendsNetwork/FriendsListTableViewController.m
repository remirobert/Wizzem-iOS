//
//  FriendsListTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import "FriendsListTableViewController.h"
#import "ContactList.h"

@interface FriendsListTableViewController ()
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) ContactList *contactList;
@end

@implementation FriendsListTableViewController

- (void)viewDidAppear:(BOOL)animated {
    PFRelation *relation = [[PFUser currentUser] objectForKey:@"friends"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else {
            self.contactList = [[ContactList alloc] initWithUsers:objects];
            NSLog(@"%@", objects);
            
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    cell.textLabel.text = [self.contactList objectForSection:indexPath.section inRow:indexPath.row];
    
    return cell;
}

@end
