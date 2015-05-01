//
//  LocationPickerViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LocationPickerViewController.h"

@interface LocationPickerViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) MKLocalSearchRequest *localSearchRequest;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) MKPinAnnotationView *annotationView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *choosePlace;
@end

@implementation LocationPickerViewController

- (IBAction)choosePlace:(id)sender {
    NSDictionary *contentLocation = @{@"place":self.annotation.title,
                                      @"lon":[NSNumber numberWithDouble:self.annotation.coordinate.longitude],
                                      @"lat":[NSNumber numberWithDouble:self.annotation.coordinate.latitude]};
    if (self.selectionBlock) {
        self.selectionBlock(contentLocation);
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)searchLocation:(id)sender {
    self.hidesBottomBarWhenPushed = false;
    [self presentViewController:self.searchController animated:true completion:nil];
}

- (IBAction)cancelSearch:(id)sender {
    if (self.selectionBlock) {
        self.selectionBlock(nil);
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.searchController dismissViewControllerAnimated:true completion:nil];
    
    NSLog(@"search complete");
    
    self.localSearchRequest = [[MKLocalSearchRequest alloc] init];
    self.localSearchRequest.naturalLanguageQuery = searchBar.text;
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:self.localSearchRequest];
    
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
       
        NSLog(@"found place");
        
        if (!response) {
            self.choosePlace.enabled = false;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Place not found" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles: nil];
            [alert show];
            return ;
        }

        self.annotation = [[MKPointAnnotation alloc] init];
        self.annotation.title = searchBar.text;
        self.annotation.coordinate = CLLocationCoordinate2DMake(response.boundingRegion.center.latitude, response.boundingRegion.center.longitude);
        
        self.annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self.annotation reuseIdentifier:nil];
        self.mapView.centerCoordinate = self.annotation.coordinate;
        [self.mapView addAnnotation:self.annotationView.annotation];
        
        self.choosePlace.enabled = true;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.choosePlace.enabled = false;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.hidesBottomBarWhenPushed = false;
    self.searchController.searchBar.delegate = self;
    
    [self presentViewController:self.searchController animated:true completion:nil];
}

@end
