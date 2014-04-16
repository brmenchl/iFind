//
//  TimelineAnnotation.h
//  iFind
//
//  Created by Bradley Menchl on 4/16/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TimelineAnnotation :NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
