//
//  MapViewController.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/24/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "MapViewController.h"
#import "UIViewController+Dismissable.h"


@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView = _mapView;

- (IBAction)selectCenter:(id)sender
{
    [self performSegueWithIdentifier:@"ShowConfirm" sender:sender];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1)) animated:YES];
}

@end
