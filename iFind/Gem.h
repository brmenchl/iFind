//
//  Gem.h
//  iFind
//
//  Created by Bradley Menchl on 3/13/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface Gem : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (id)initWithPFObject:(PFObject *)object;
- (BOOL)equalToGem:(Gem *)other;


@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;
@property (nonatomic, assign) BOOL animatesDrop;

@end