//
//  HomeViewController.h
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface HomeViewController : UIViewController <RKObjectLoaderDelegate>

@property (strong) IBOutlet UIView* pendingView;
@property (strong) IBOutlet UIView* createView;
@property (strong) IBOutlet UIView* pickupView;
@property (strong) IBOutlet MKMapView* mapView;
@property (strong) IBOutlet UIButton* requestButton;

-(IBAction)requestNow:(id)sender;
-(IBAction)requestLater:(id)sender;
-(IBAction)cancelRequest:(id)sender;

@end
