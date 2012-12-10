//
//  AppDelegate.m
//  BusPlus
//
//  Created by Aubrey Goodman on 11/23/12.
//  Copyright (c) 2012 Migrant Studios. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set up RestKit
    RKObjectManager* tMgr = [RKObjectManager managerWithBaseURLString:@"http://buspl.us/api"];
    tMgr.client.requestQueue.concurrentRequestsLimit = 1;
    tMgr.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"BusPlus.sqlite3"];
    
    [Passenger initObjectLoader:tMgr];
    [Vehicle initObjectLoader:tMgr];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[RKObjectManager sharedManager].objectStore save:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push notification

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    async_main(^{
        if( [[error.userInfo description] rangeOfString:@"simulator"].location!=NSNotFound ) {
            NSLog(@"simulating push notification");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotificationEnabled" object:@"abc123"];
        }else{
            NSLog(@"push notification error: %@",error.userInfo);
            Alert(@"Push Notification Required", @"An error was encountered");
        }
    });
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    async_main(^{
        NSString* tRaw = [deviceToken description];
        NSString* tToken = [[[tRaw stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotificationEnabled" object:tToken];
    });
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"remote notification: %@",userInfo);
    NSNumber* tVehicleId = [userInfo valueForKey:@"vehicle_id"];
    if( tVehicleId ) {
        Passenger* tPassenger = [Passenger findFirst];
        [[RKObjectManager sharedManager] getObject:tPassenger delegate:self];
        
        Vehicle* tVehicle = [Vehicle object];
        tVehicle.vehicleId = tVehicleId;
        [[RKObjectManager sharedManager] getObject:tVehicle delegate:self];
    }
    
    NSNumber* tRejected = [userInfo valueForKey:@"rejected"];
    if( tRejected.boolValue ) {
        async_main(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PassengerRejected" object:nil];
        });
    }
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Web Service Error\nrequest: %@ %@ %@\nresponse: %@",(objectLoader.response.request.method==RKRequestMethodGET ? @"GET" : (objectLoader.response.request.method==RKRequestMethodPUT ? @"PUT" : (objectLoader.response.request.method==RKRequestMethodPOST ? @"POST" : (objectLoader.response.request.method==RKRequestMethodDELETE ? @"DELETE" : @"???" )))),objectLoader.resourcePath,objectLoader.response.request.HTTPBodyString,objectLoader.response.bodyAsString);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    if( [object isKindOfClass:[Passenger class]] ) {
        NSLog(@"passenger assigned: %@",object);
    }
    if( [object isKindOfClass:[Vehicle class]] ) {
        NSLog(@"vehicle received: %@",object);
        async_main(^{
            Passenger* tPassenger = [Passenger findFirst];
            tPassenger.vehicle = (Vehicle*)object;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PassengerUpdated" object:nil];
        });
    }
}

@end
