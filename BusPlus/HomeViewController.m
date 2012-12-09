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

- (IBAction)cancelRequest:(id)sender
{
    Passenger* tPassenger = [Passenger findFirst];
    [[RKObjectManager sharedManager] deleteObject:tPassenger delegate:self];
}

- (void)passengerUpdated:(NSNotification*)aNotif
{
    async_main(^{
        [self viewWillAppear:NO];
    });
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passengerUpdated:) name:@"PassengerUpdated" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    Passenger* tPassenger = [Passenger findFirst];
    if( tPassenger ) {
        self.pendingView.hidden = NO;
        self.createView.hidden = YES;
    }else{
        self.pendingView.hidden = YES;
        self.createView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Passenger Web Error: %@",objectLoader.response.bodyAsString);
    async_main(^{
        Alert(@"Unable To Cancel Request", [error localizedDescription]);
    });
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    NSLog(@"passenger deleted");
    async_main(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassengerUpdated" object:nil];
    });
}

@end
