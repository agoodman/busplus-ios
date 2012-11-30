//
//  UIViewController+Dismissable.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "UIViewController+Dismissable.h"

@implementation UIViewController (Dismissable)

- (IBAction)dismiss:(id)sender
{
    async_global(^{
        [Passenger truncateAll];
        [Vehicle truncateAll];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
