//
//  NewMetadataViewController.h
//  iFind
//
//  Created by Bradley Menchl on 4/14/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TimelineAccordianView.h"

@interface NewMetadataViewController : UIViewController <TimelineAccordianViewDelegate>
@property (nonatomic) TimelineAccordianView *accordianView;
@property (nonatomic) PFObject *theMetadata;

-(id)initWithMetadata:(PFObject *)metadata;
@end
