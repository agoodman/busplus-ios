//
//  DestinationTypeSelectViewController.h
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DestinationTypeSelectViewController : UIViewController

-(IBAction)cancelRequest:(id)sender;
-(IBAction)requestByAddress:(id)sender;
-(IBAction)requestByLatLng:(id)sender;
-(IBAction)requestByPOI:(id)sender;

@end
