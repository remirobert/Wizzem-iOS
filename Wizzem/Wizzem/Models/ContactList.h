//
//  ContactList.h
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactList : NSObject

@property (nonatomic, strong) NSArray *sections;

- (NSString *)objectForSection:(NSInteger)section inRow:(NSInteger)row;
- (NSInteger)countObjectsForSection:(NSInteger)section;
- (instancetype)initWithUsers:(NSArray *)users;
- (instancetype)initWithContacts:(NSArray *)contacts;

@end
