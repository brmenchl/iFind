//
//  LocationManager.m
//  iFind
//
//  Created by Andrew Milenius on 4/8/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "LocationManager.h"
#import "AppDelegate.h"
#import <math.h>



@interface LocationManager(){
    
}



@end

@implementation LocationManager


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc] init];

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        
        self.currentLocation = self.locationManager.location;
        
        if (self.currentLocation){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.currentLocation = self.currentLocation;
        }
        

    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateHeading" object:manager];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"didUpdateLocations");
    //Set global reference to current location
	self.currentLocation = [locations lastObject];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = self.currentLocation;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateLocationNotification" object:manager];

}




@end
