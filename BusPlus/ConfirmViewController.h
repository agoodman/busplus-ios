//
//  ConfirmViewController.h
//  BusPlus
//
//  Created by Aubrey Goodman on 11/24/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ConfirmViewController : UIViewController

@property (strong) IBOutlet UILabel* destinationLabel;
@property (strong) IBOutlet MKMapView* mapView;

@end
