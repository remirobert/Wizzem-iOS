//
//  SelectFriendsTableViewController.h
//  Wizzem
//
//  Created by Remi Robert on 04/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFriendsTableViewController : UITableViewController

@property (nonatomic, strong) void (^blockCompletion)(NSArray *users);
@property (nonatomic, strong) NSMutableArray *selectedUsers;

@end
