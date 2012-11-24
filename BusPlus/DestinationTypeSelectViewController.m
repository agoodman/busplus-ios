//
//  DestinationTypeSelectViewController.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "DestinationTypeSelectViewController.h"

@interface DestinationTypeSelectViewController ()

@end

@implementation DestinationTypeSelectViewController

- (IBAction)cancelRequest:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)requestByAddress:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRequestByAddress" sender:sender];
}

- (IBAction)requestByLatLng:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRequestByLatLng" sender:sender];
}

- (IBAction)requestByPOI:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRequestByPOI" sender:sender];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
