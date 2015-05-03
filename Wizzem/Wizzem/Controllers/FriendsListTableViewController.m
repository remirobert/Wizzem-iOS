//
//  FriendsListTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import "FriendsListTableViewController.h"

@interface FriendsListTableViewController ()
@property (nonatomic, strong) NSArray *friends;
@end

@implementation FriendsListTableViewController

- (void)viewDidAppear:(BOOL)animated {
    PFRelation *relation = [[PFUser currentUser] objectForKey:@"friends"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"friends : %@", objects);
        self.friends = [NSArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellUser"];
    cell.textLabel.text = ((PFUser *)[self.friends objectAtIndex:indexPath.row]).username;
    
    return cell;
}

@end
