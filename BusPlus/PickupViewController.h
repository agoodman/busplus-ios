//
//  PickupViewController.h
//  BusPlus
//
//  Created by Aubrey Goodman on 11/29/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface PickupViewController : UIViewController <CLLocationManagerDelegate>

@property (strong) IBOutlet CLLocationManager* locationManager;

-(IBAction)useCurrentLocation:(id)sender;
-(IBAction)useMap:(id)sender;

@end
