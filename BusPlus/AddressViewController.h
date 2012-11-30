//
//  AddressViewController.h
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddressViewController : UIViewController <UITextFieldDelegate>

@property (strong) IBOutlet UITextField* addressField;

-(IBAction)nextButtonPressed:(id)sender;

@end
