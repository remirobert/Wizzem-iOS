//
//  FeedCollectionViewController.m
//  Wizzem
//
//  Created by Remi Robert on 25/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "FeedCollectionViewController.h"
#import <Parse/Parse.h>
#import <ParseUI.h>

@interface FeedCollectionViewController ()

@end

@implementation FeedCollectionViewController

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                                cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                                object:(PFObject *)object {
    PFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mediaCell" forIndexPath:indexPath];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.layer.masksToBounds = true;
    cell.imageView.file = [object objectForKey:@"file"];
    [cell.imageView loadInBackground];
    return cell;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"eventId" containsString:self.wizz.objectId];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Media";
        self.pullToRefreshEnabled = true;
        self.paginationEnabled = false;
        self.objectsPerPage = 30;
        self.hidesBottomBarWhenPushed = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[PFCollectionViewCell class] forCellWithReuseIdentifier:@"mediaCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
