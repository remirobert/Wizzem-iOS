//
//  Friends.m
//  Wizzem
//
//  Created by Remi Robert on 04/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "Friends.h"


@implementation Friend

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.username forKey:@"username"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
    }
    return self;
}

@end

@implementation Friends

- (NSMutableArray *)friends {
    if (!_friends) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.friends forKey:@"friends"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.friends = [aDecoder decodeObjectForKey:@"friends"];
    }
    return self;
}

- (void)addFriend:(NSString *)username withEmail:(NSString *)email {
    Friend *newFriend = [Friend new];
    newFriend.email = email;
    newFriend.username = username;
    [self.friends addObject:newFriend];
}

- (void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@[self]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"friends"];
}

+ (instancetype)instance {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"friends"];
    NSArray *friends = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [friends firstObject];
}

@end
