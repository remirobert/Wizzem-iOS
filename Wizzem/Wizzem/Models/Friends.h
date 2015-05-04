//
//  Friends.h
//  Wizzem
//
//  Created by Remi Robert on 04/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Friends : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray *friends;

- (void)addFriend:(NSString *)username withEmail:(NSString *)email;
- (void)save;
+ (instancetype)instance;

@end
