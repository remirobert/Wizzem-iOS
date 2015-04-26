//
//  User.m
//  Wizzem
//
//  Created by Remi Robert on 26/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "PFObject+NSCoding.h"
#import "User.h"

@interface User() <NSCoding>
@property (nonatomic, strong) PFUser *parseUser;
@end

@implementation User

#pragma mark -
#pragma mark setter getter

- (void)setPassword:(NSString *)password {
    self.password = password;
    self.parseUser.password = password;
}

- (void)setEmail:(NSString *)email {
    self.email = email;
    self.parseUser.email = email;
}

- (void)setUsername:(NSString *)username {
    self.username = username;
    self.parseUser.username = username;
}

#pragma mark -
#pragma mark singleton

+ (instancetype)instance {
    static User *user;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
        
        user.parseUser = [PFUser user];
        user.parseUser.email = user.email;
        user.parseUser.password = user.password;
        user.parseUser.username = user.username;
    });
    return user;
}

#pragma mark -
#pragma mark NSCoding protocol

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
