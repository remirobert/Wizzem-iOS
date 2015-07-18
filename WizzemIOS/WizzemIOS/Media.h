//
//  Media.h
//  
//
//  Created by Remi Robert on 04/07/15.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GIF,
    PHOTO,
} MediaType;

@interface Media : NSObject
@property (nonatomic, strong) NSData *dataMedia;
@property (nonatomic, assign) MediaType type;

- (instancetype)initWithData:(NSData *)data andType:(MediaType)type;

@end
