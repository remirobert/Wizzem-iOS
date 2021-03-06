//
//  User.m
//  Wizzem
//
//  Created by Remi Robert on 26/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "User.h"

@interface User() <NSCoding>
@property (nonatomic, strong) PFUser *parseUser;
@end

@implementation User

#pragma mark -
#pragma mark Parse API

- (BOOL)isAuthenticated {
    return [self.parseUser isAuthenticated];
}

#pragma mark -
#pragma mark setter getter

- (void)setPassword:(NSString *)password {
    _password = password;
    _parseUser.password = password;
}

- (void)setEmail:(NSString *)email {
    _email = email;
    _parseUser.email = email;
}

- (void)setUsername:(NSString *)username {
    _username = username;
    _parseUser.username = username;
}

#pragma mark -
#pragma mark singleton

- (void)initParseModel {
    self.parseUser = [[PFUser alloc] init];
    if (self.email) {
        self.parseUser.email = self.email;
    }
    if (self.password) {
        self.parseUser.password = self.password;
    }
    if (self.username) {
        self.parseUser.username = self.username;
    }
}

+ (instancetype)instance {
    static User *user;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        user = [User restaure];
        if (!user) {
            user = [[User alloc] init];
        }
        [user initParseModel];
    });
    return user;
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@[self]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
}

+ (instancetype)restaure {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (data) {
        NSArray *users = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return [users firstObject];
    }
    return  nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.username forKey:@"username"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
    }
    return self;
}

@end
