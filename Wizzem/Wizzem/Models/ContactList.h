//
//  ContactList.h
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface ContactList : NSObject

@property (nonatomic, strong) NSArray *sections;

- (PFUser *)objectForSection:(NSInteger)section inRow:(NSInteger)row;
- (NSInteger)countObjectsForSection:(NSInteger)section;
- (void)removeUser:(PFUser *)user;
- (instancetype)initWithUsers:(NSArray *)users;

@end
