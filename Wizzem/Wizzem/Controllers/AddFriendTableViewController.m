//
//  AddFriendTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "AddFriendTableViewController.h"

@interface AddFriendTableViewController () <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation AddFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        ABPeoplePickerNavigationController *picker =
        [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        
        [self presentViewController:picker animated:true completion:nil];
    }
}

@end
