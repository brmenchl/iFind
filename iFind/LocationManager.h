//
//  LocationManager.h
//  iFind
//
//  Created by Andrew Milenius on 4/8/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>


@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
