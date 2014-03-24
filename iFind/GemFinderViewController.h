//
//  GemFinderViewController.h
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LeaveGemViewController.h"
@class MKMapView;
@class GemFinderViewController;

@protocol GemFinderViewControllerDelegate <NSObject>
@end

@interface GemFinderViewController : UIViewController <CLLocationManagerDelegate, LeaveGemViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *dropButton;
@property (weak, nonatomic) IBOutlet UIButton *pickUpButton;

- (IBAction)dropButtonPress:(id)sender;
- (IBAction)pickUpButtonPress:(id)sender;

- (void)dropGemWithContent:(NSArray *)content;

@property (nonatomic, assign) id<GemFinderViewControllerDelegate> delegate;
@end
