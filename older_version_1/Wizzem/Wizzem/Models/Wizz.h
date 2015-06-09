//
//  Wizz.h
//  Wizzem
//
//  Created by Remi Robert on 29/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface Wizz : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, assign) NSInteger numberParticipant;

+ (instancetype)sharedInstance:(BOOL)reset;
- (NSDictionary *)dictionary;

@end
