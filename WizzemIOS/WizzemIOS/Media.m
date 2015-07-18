//
//  Media.m
//  
//
//  Created by Remi Robert on 04/07/15.
//
//

#import "Media.h"

@implementation Media

- (instancetype)initWithData:(NSData *)data andType:(MediaType)type {
    self = [super init];
    
    if (self) {
        self.dataMedia = data;
        self.type = type;
    }
    return self;
}

@end
