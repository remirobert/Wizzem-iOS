//
//  ContactList.m
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import "ContactList.h"

@interface ContactList()
@property (nonatomic, strong) NSMutableDictionary *contentList;
@end

@implementation NSDictionary (List)

- (BOOL)containsKey:(NSString *)key {
    return [self.allKeys containsObject:key];
}

- (NSString *)keyFromIndex:(NSInteger)index {
    return [self.allKeys objectAtIndex:index];
}

@end

@implementation ContactList

- (NSMutableDictionary *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableDictionary dictionary];
    }
    return _contentList;
}

- (PFUser *)objectForSection:(NSInteger)section inRow:(NSInteger)row {
    return [((NSMutableArray *)[self.contentList objectForKey:[self.contentList keyFromIndex:section]]) objectAtIndex:row];
}

- (NSInteger)countObjectsForSection:(NSInteger)section {
    return ((NSMutableArray *)[self.contentList objectForKey:[self.contentList keyFromIndex:section]]).count;
}

- (void)removeUser:(PFUser *)user {
    for (NSMutableArray *users in self.contentList) {
        
        if ([users containsObject:user]) {
            [users removeObject:user];
            if (users.count == 0) {
                NSString *key = [NSString stringWithFormat:@"%c", [[user.username uppercaseString] characterAtIndex:0]];
                [self.contentList removeObjectForKey:key];
            }
            return;
        }
    }
}

#pragma mark -
#pragma mark PFUser

- (void)parseUsers:(NSArray *)users {
    for (PFUser *currentUser in users) {
        
        NSString *currentKey = [NSString stringWithFormat:@"%c", [[currentUser.username uppercaseString] characterAtIndex:0]];
        
        if ([self.contentList containsKey:currentKey]) {
            [((NSMutableArray *)[self.contentList objectForKey:currentKey]) addObject:currentUser];
        }
        else {
            [self.contentList setObject:[NSMutableArray array] forKey:currentKey];
            [((NSMutableArray *)[self.contentList objectForKey:currentKey]) addObject:currentUser];
        }
    }
}

- (NSArray *)orderList:(NSArray *)list {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [list sortedArrayUsingDescriptors:sortDescriptors];
}


- (instancetype)initWithUsers:(NSArray *)users {
    self = [super init];
    
    if (self) {
        [self parseUsers:users];
        self.sections = [self.contentList allKeys];
    }
    return self;
}

@end
