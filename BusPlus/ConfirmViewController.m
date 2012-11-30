//
//  ConfirmViewController.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/24/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "ConfirmViewController.h"
#import "UIViewController+Dismissable.h"


@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

@synthesize destinationLabel = _destinationLabel, mapView = _mapView;

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    async_global(^{
        Passenger* tPassenger = [Passenger findFirst];
    double tStartLat = tPassenger.startLatitude.doubleValue,
        tStartLng = tPassenger.startLongitude.doubleValue,
        tEndLat = tPassenger.endLatitude.doubleValue,
        tEndLng = tPassenger.endLongitude.doubleValue,
        tLatSpan = (tStartLat - tEndLat)*1.1,
        tLngSpan = (tStartLng - tEndLng)*1.1;
    if( tLatSpan<0 ) tLatSpan = -tLatSpan;
    if( tLngSpan<0 ) tLngSpan = -tLngSpan;
    NSLog(@"passenger start: %3.6f, %3.6f  end: %3.6f, %3.6f span: %1.2f, %1.2f",tStartLat,tStartLng,tEndLat,tEndLng,tLatSpan,tLngSpan);
    
        async_main(^{
            self.destinationLabel.text = tPassenger.destinationDisplay;
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake((tStartLat+tEndLat)/2.0, (tStartLng+tEndLng)/2.0), MKCoordinateSpanMake(tLatSpan, tLngSpan)) animated:NO];
            
            // overlays
            [self.mapView removeOverlays:self.mapView.overlays];
            CLLocationCoordinate2D *tCoords = malloc(sizeof(CLLocationCoordinate2D) * 2);
            tCoords[0] = CLLocationCoordinate2DMake(tStartLat, tStartLng);
            tCoords[1] = CLLocationCoordinate2DMake(tEndLat, tEndLng);
            MKPolyline* tArrow = [MKPolyline polylineWithCoordinates:tCoords count:2];
            [self.mapView addOverlay:tArrow];
            
            MKCircle* tPickup = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(tStartLat, tStartLng) radius:tLngSpan/5.0];
            MKCircle* tDestination = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(tEndLat, tEndLng) radius:tLngSpan/5.0];
            [self.mapView addOverlay:tPickup];
            [self.mapView addOverlay:tDestination];
        });
//    });
}


#pragma mark - MKMapViewDelegate

- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ( [overlay isKindOfClass:[MKCircle class]] ) {
        MKCircleView* tView = [[MKCircleView alloc] initWithCircle:(MKCircle*)overlay];
        
        tView.fillColor = tView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.75];
//        tView.lineWidth = 1.0;

        
        return tView;
    }
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView* tView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline*)overlay];
        
        tView.fillColor = tView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        tView.lineWidth = 0;
        
        return tView;
    }
    
    return nil;
}

@end
