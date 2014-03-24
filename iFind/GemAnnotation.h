//
//  GemAnnotation.h
//  iFind
//
//  Created by Bradley Menchl on 3/13/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface GemAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (id)initWithPFObject:(PFObject *)object;
- (BOOL)equalToGem:(GemAnnotation *)other;


@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;

@end