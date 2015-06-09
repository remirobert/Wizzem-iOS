//
//  FeedCollectionViewController.h
//  Wizzem
//
//  Created by Remi Robert on 25/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse.h>
#import "PFQueryCollectionViewController.h"

@interface FeedCollectionViewController : PFQueryCollectionViewController

@property (nonatomic, strong) PFObject *wizz;

@end
