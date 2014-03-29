//
//  Gem.m
//  iFind
//
//  Created by Bradley Menchl on 3/13/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GemAnnotation.h"
#import "AppDelegate.h"

@interface GemAnnotation ()
//Stored PFObject reference
@property (nonatomic, strong) PFObject *object;
//Stored Parse location point reference
@property (nonatomic, strong) PFGeoPoint *geopoint;
@end

@implementation GemAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    if ((self = [super init])) {
        self.coordinate = coord;
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)theObject {
    [theObject fetchIfNeeded];

	self.object = theObject;
	self.geopoint = [theObject objectForKey:ParseGemCurrentLocationKey];
    
	CLLocationCoordinate2D objectCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
    //Set required coordinate property to show up on the map
	return [self initWithCoordinate:objectCoordinate];
}

- (BOOL) equalToGem:(GemAnnotation *)other {
    if(other == nil) {
        return NO;
    }
    if(other.object && self.object) {
        //Gem has PFObject stored inside it.  Use that.
        if([other.object.objectId compare:self.object.objectId] != NSOrderedSame) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        if(other.geopoint.latitude != self.geopoint.latitude &&
           other.geopoint.longitude != self.geopoint.longitude) {
            return NO;
        }
        else {
            return YES;
        }
    }
}
@end