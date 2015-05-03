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

- (NSString *)objectForSection:(NSInteger)section inRow:(NSInteger)row {
    return [((NSMutableArray *)[self.contentList objectForKey:[self.contentList keyFromIndex:section]]) objectAtIndex:row];
}

- (NSInteger)countObjectsForSection:(NSInteger)section {
    return ((NSMutableArray *)[self.contentList objectForKey:[self.contentList keyFromIndex:section]]).count;
}

- (void)parseUsers:(NSArray *)users {
    for (PFUser *currentUser in users) {
        
        NSString *currentKey = [NSString stringWithFormat:@"%c", [[currentUser.username uppercaseString] characterAtIndex:0]];
        
        if ([self.contentList containsKey:currentKey]) {
            [((NSMutableArray *)[self.contentList objectForKey:currentKey]) addObject:currentUser.username];
        }
        else {
            [self.contentList setObject:[NSMutableArray array] forKey:currentKey];
            [((NSMutableArray *)[self.contentList objectForKey:currentKey]) addObject:currentUser.username];
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
        [self parseUsers:[self orderList:users]];
        self.sections = [self.contentList allKeys];
    }
    return self;
}

@end
