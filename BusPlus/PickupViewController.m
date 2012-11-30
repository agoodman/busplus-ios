//
//  PickupViewController.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/29/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "PickupViewController.h"

@interface PickupViewController ()

@end

@implementation PickupViewController

@synthesize locationManager = _locationManager;

- (IBAction)useCurrentLocation:(id)sender
{
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (IBAction)useMap:(id)sender
{
    Alert(@"TODO", @"pick location using map");
}

- (void)createPassenger
{
//    async_global(^{
        Passenger* tPassenger = [Passenger object];
        tPassenger.startLatitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude];
        tPassenger.startLongitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude];

//        async_main(^{
            [self performSegueWithIdentifier:@"ShowDestination" sender:self];
//        });
//    });
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation* location in locations) {
        if( location.horizontalAccuracy<100 ) {
            [manager stopUpdatingLocation];
            [self createPassenger];
            break;
        }
    }
}

@end
