//
//  TimelineAccordianView.h
//  iFind
//
//  Created by Bradley Menchl on 4/9/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TimelineAccordianViewDelegate.h"

@interface TimelineAccordianView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id <TimelineAccordianViewDelegate> delegate;

@property (nonatomic) PFObject *metadata;

@property (nonatomic) BOOL opened;

@property (nonatomic) CGFloat drawerHeight;

- (void) handleTap:(id)sender;

@end