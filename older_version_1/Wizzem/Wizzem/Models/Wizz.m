//
//  Wizz.m
//  Wizzem
//
//  Created by Remi Robert on 29/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "Wizz.h"

@implementation Wizz

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.isPublic = false;
        self.numberParticipant = 0;
        self.comment = @"";
        self.start = [NSDate new];
    }
    return self;
}

+ (instancetype)sharedInstance:(BOOL)reset {
    static Wizz *wizz;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        wizz = [Wizz new];
    });
    
    if (reset) {
        wizz = [Wizz new];
    }

    return wizz;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *content = [NSMutableDictionary dictionary];

    [content setObject:self.title forKey:@"title"];
    if (self.comment) {
        [content setObject:self.comment forKey:@"description"];
    }
    if (self.start) {
        [content setObject:self.start forKey:@"start"];
    }
    else {
        [content setObject:[NSDate date] forKey:@"start"];
    }
    if (self.end) {
        [content setObject:self.end forKey:@"end"];
    }
    if (self.location) {
        [content setObject:self.location forKey:@"location"];
    }
    if (self.numberParticipant) {
        [content setObject:@(self.numberParticipant) forKey:@"nbMaxParticipant"];
    }
    [content setObject:@(self.isPublic) forKey:@"public"];

    return (NSDictionary *)content;
}

@end
