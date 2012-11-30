//
//  AddressViewController.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "AddressViewController.h"
#import "UIViewController+Dismissable.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>


@interface AddressViewController ()

@end

@implementation AddressViewController

- (IBAction)nextButtonPressed:(id)sender
{
    [self updatePassenger];
}

- (void)updatePassenger
{
    NSString* tAddress = self.addressField.text;
    CLGeocoder* tGeocoder = [[CLGeocoder alloc] init];
    [tGeocoder geocodeAddressString:tAddress completionHandler:^(NSArray* aArray, NSError* aError) {
        if( aArray.count>0 ) {
            CLPlacemark* tPlacemark = [aArray objectAtIndex:0];
            
//            async_global(^{
                Passenger* tPassenger = [Passenger findFirst];
                tPassenger.endLatitude = [NSNumber numberWithDouble:tPlacemark.location.coordinate.latitude];
                tPassenger.endLongitude = [NSNumber numberWithDouble:tPlacemark.location.coordinate.longitude];
                tPassenger.destinationDisplay = ABCreateStringWithAddressDictionary(tPlacemark.addressDictionary, NO);
                
                async_main(^{
                    [self performSegueWithIdentifier:@"ShowConfirm" sender:self];
                });
//            });
        }else{
            async_main(^{
                Alert(@"Unable to Find Address", @"Please Try Again");
            });
        }
    }];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.addressField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self updatePassenger];
    return YES;
}

@end
