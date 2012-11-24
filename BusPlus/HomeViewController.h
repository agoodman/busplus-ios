//
//  HomeViewController.h
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (strong) IBOutlet UIView* pendingView;
@property (strong) IBOutlet UIView* createView;
@property (strong) IBOutlet UIButton* requestButton;

-(IBAction)requestNow:(id)sender;
-(IBAction)requestLater:(id)sender;

@end
