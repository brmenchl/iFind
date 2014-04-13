//
//  TimelineAccordianViewDelegate.h
//  iFind
//
//  Created by Bradley Menchl on 4/9/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimelineAccordianView;

@protocol TimelineAccordianViewDelegate <NSObject>

- (void) expandView:(TimelineAccordianView *)view;

@end
