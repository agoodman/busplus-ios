//
//  MapViewController.h
//  BusPlus
//
//  Created by Aubrey Goodman on 11/24/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong) IBOutlet MKMapView* mapView;

-(IBAction)selectCenter:(id)sender;

@end
