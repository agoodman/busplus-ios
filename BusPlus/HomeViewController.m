//
//  HomeViewController.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize pendingView = _pendingView, createView = _createView, pickupView = _pickupView, mapView = _mapView, requestButton = _requestButton, activeVehiclesLabel = _activeVehiclesLabel, locationManager = _locationManager;

- (IBAction)requestNow:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRequestNow" sender:sender];
}

- (IBAction)requestLater:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRequestLater" sender:sender];
}

- (IBAction)cancelRequest:(id)sender
{
    Passenger* tPassenger = [Passenger findFirst];
    [[RKObjectManager sharedManager] deleteObject:tPassenger delegate:self];
}

- (void)confirmVehicleAvailability
{
    if( self.locationManager.location ) {
        NSString* tVehicleCountPath = [@"/api/vehicles/near" stringByAppendingQueryParameters:@{ @"latitude" : [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude], @"longitude" : [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude]}];
        dispatch_block_t tTask = ^{
            NSURL* tUrl = [NSURL URLWithString:tVehicleCountPath relativeToURL:[RKObjectManager sharedManager].baseURL.standardizedURL];
            NSString* tRsp = [NSString stringWithContentsOfURL:tUrl encoding:NSUTF8StringEncoding error:nil];
            int tCount = 0;
            if( tRsp ) {
                NSNumberFormatter* tFormat = [[NSNumberFormatter alloc] init];
                tFormat.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber* tNumber = [tFormat numberFromString:tRsp];
                tCount = tNumber.intValue;
            }
            dispatch_block_t tCallback = ^{
                if( tCount>0 ) {
                    self.requestButton.enabled = YES;
                    if( tCount==1 ) {
                        self.activeVehiclesLabel.text = [NSString stringWithFormat:@"There is one vehicle in your area"];
                    }else{
                        self.activeVehiclesLabel.text = [NSString stringWithFormat:@"There are %d vehicles in your area",tCount];
                    }
                }else{
                    self.requestButton.enabled = NO;
                    self.activeVehiclesLabel.text = [NSString stringWithFormat:@"There are no vehicles in your area"];
                }
            };
            async_main(tCallback);
        };
        async_global(tTask);
    }
}

- (void)passengerUpdated:(NSNotification*)aNotif
{
    async_main(^{
        [self viewWillAppear:NO];
    });
}

- (void)passengerRejected:(NSNotification*)aNotif
{
    async_main(^{
        Alert(@"No Vehicles Available", @"Unable to find a vehicle in your area");
        [self cancelRequest:nil];
    });
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passengerUpdated:) name:@"PassengerUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passengerRejected:) name:@"PassengerRejected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmVehicleAvailability) name:@"AppBecameActive" object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    Passenger* tPassenger = [Passenger findFirst];
    if( tPassenger && tPassenger.assignedAt ) {
        double tLat = (tPassenger.vehicle.latitude.doubleValue+tPassenger.startLatitude.doubleValue)/2.0,
            tLng = (tPassenger.vehicle.longitude.doubleValue+tPassenger.startLongitude.doubleValue)/2.0,
            tRng = MAX(abs(tPassenger.vehicle.latitude.doubleValue-tPassenger.startLatitude.doubleValue),abs(tPassenger.vehicle.longitude.doubleValue-tPassenger.startLongitude.doubleValue));
        
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(tLat,tLng), MKCoordinateSpanMake(tRng,tRng)) animated:NO];
        self.pendingView.hidden = self.createView.hidden = YES;
        self.pickupView.hidden = NO;
    }else if( tPassenger ) {
        self.createView.hidden = self.pickupView.hidden = YES;
        self.pendingView.hidden = NO;
    }else{
        self.pendingView.hidden = self.pickupView.hidden = YES;
        self.createView.hidden = NO;
        [self confirmVehicleAvailability];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Passenger Web Error: %@",objectLoader.response.bodyAsString);
    async_main(^{
        Alert(@"Unable To Cancel Request", [error localizedDescription]);
    });
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    NSLog(@"passenger deleted");
    async_main(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassengerUpdated" object:nil];
    });
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location manager error: %@",[error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation* location in locations) {
        if( location.horizontalAccuracy<500 ) {
            [manager stopUpdatingLocation];
            break;
        }
    }
}

@end
