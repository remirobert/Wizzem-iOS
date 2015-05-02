//
//  Wizz.m
//  Wizzem
//
//  Created by Remi Robert on 29/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "Wizz.h"

@implementation Wizz

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

@end
