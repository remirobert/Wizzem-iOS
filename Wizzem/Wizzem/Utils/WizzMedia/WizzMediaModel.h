//
//  WizzMediaModel.h
//  Wizzem
//
//  Created by Remi Robert on 23/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizzMedia.h"

@interface WizzMediaModel : UITableViewCell

@property (nonatomic, assign, readonly) WizzMediaType mediaType;

- (UIImage *)photo;
- (NSData *)gif;
- (NSURL *)video;
- (NSURL *)audio;
- (instancetype)init:(WizzMediaType)type genericObjectMedia:(id)media;

@end
