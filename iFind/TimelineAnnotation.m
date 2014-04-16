//
//  TimelineAnnotation.m
//  iFind
//
//  Created by Bradley Menchl on 4/16/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "TimelineAnnotation.h"

@implementation TimelineAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        self.coordinate =coordinate;
    }
    return self;
}


@end
