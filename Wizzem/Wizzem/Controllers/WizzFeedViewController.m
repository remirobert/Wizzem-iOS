//
//  WizzFeedViewController.m
//  Wizzem
//
//  Created by Remi Robert on 17/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <Parse/Parse.h>
#import "WizzFeedViewController.h"
#import "FeedCollectionViewController.h"

@interface WizzFeedViewController ()
@property (nonatomic, strong) PFObject *selectedWizz;
@end

@implementation WizzFeedViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = object[@"title"];
    return cell;
}
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedWizz = [self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"wizzDetailSegue" sender:nil];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Event";
        self.pullToRefreshEnabled = true;
        self.paginationEnabled = false;
        self.objectsPerPage = 20;
        self.hidesBottomBarWhenPushed = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"wizzDetailSegue"]) {
        ((FeedCollectionViewController *)segue.destinationViewController).wizz = self.selectedWizz;
    }
}

@end
