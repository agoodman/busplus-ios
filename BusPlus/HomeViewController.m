//
//  HomeViewController.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize pendingView = _pendingView, createView = _createView, requestButton = _requestButton;

- (IBAction)requestNow:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRequestNow" sender:sender];
}

- (IBAction)requestLater:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRequestLater" sender:sender];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pendingView.hidden = YES;
    self.createView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
