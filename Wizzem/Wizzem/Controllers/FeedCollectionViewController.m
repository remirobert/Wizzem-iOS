//
//  FeedCollectionViewController.m
//  Wizzem
//
//  Created by Remi Robert on 25/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI.h>
#import "FeedCollectionViewController.h"
#import "HeaderCollectionReusableView.h"
#import "DetailWizzMediaViewController.h"

@interface FeedCollectionViewController ()
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) PFObject *selectedObject;
@end

@implementation FeedCollectionViewController

@synthesize collectionViewLayout;

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                                cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                                object:(PFObject *)object {
    PFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mediaCell" forIndexPath:indexPath];
    
    cell.imageView.image = nil;
    cell.imageView.file = nil;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.layer.masksToBounds = true;

    cell.imageView.file = [object objectForKey:@"file"];
    [cell.imageView loadInBackground];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        header.titleWizz.text = self.wizz[@"title"];
        return header;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedObject = [self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailMediaWizzSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailMediaWizzSegue"]) {
        ((DetailWizzMediaViewController *)segue.destinationViewController).media = self.selectedObject;
    }
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
    self.collectionViewLayout.itemSize =  CGSizeMake(self.view.frame.size.width / 3 - 15, self.view.frame.size.width / 3 - 15);
    self.collectionViewLayout.minimumInteritemSpacing = 5;
    self.collectionViewLayout.minimumLineSpacing = 5;
    [self.collectionView registerClass:[PFCollectionViewCell class] forCellWithReuseIdentifier:@"mediaCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
