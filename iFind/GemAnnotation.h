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

//THIS ENTIRE CLASS IS ONLY TEMPORARY FOR MAPVIEW

@interface GemAnnotation : NSObject <MKAnnotation> //NEEDS TO BE SUBCLASS OF MKAnnotation
//Required public property coordinate
@property (nonatomic) CLLocationCoordinate2D coordinate;

//Init with simple coordinates
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
//Init given a PFObject
- (id)initWithPFObject:(PFObject *)object;
//Equality test
- (BOOL)equalToGem:(GemAnnotation *)other;

//Public property for PFObject
@property (nonatomic, readonly, strong) PFObject *object;
//Public propert for current Parse Geopoint (this is how we store gem locations)
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;

@end