//
//  WizzMediaModel.m
//  Wizzem
//
//  Created by Remi Robert on 23/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzMediaModel.h"

@interface WizzMediaModel()
@property (nonatomic, strong) id mediaData;
@property (nonatomic, assign) WizzMediaType mediaType;
@end

@implementation WizzMediaModel

- (UIImage *)photo {
    if (self.mediaType != WizzMediaPhoto) {
        return nil;
    }
    return (UIImage *)self.mediaData;
}

- (NSData *)gif {
    if (self.mediaType != WizzMediaGif) {
        return nil;
    }
    return (NSData *)self.mediaData;
}

- (NSURL *)video {
    if (self.mediaType != WizzMediaVideo) {
        return nil;
    }
    return (NSURL *)self.mediaData;
}

- (NSURL *)audio {
    if (self.mediaType != WizzMediaSong) {
        return nil;
    }
    return (NSURL *)self.mediaData;
}

- (instancetype)init:(WizzMediaType)type genericObjectMedia:(id)media {
    self = [super init];
    
    if (self) {
        self.mediaData = media;
    }
    return self;
}

@end
