//
//  LocationManager.m
//  iFind
//
//  Created by Andrew Milenius on 4/8/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "LocationManager.h"


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
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        
        [self.locationManager startUpdatingLocation];
        
        self.currentLocation = self.locationManager.location;
        

    }
    
    return self;
}



@end
