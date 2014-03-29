//
//  GemFinderViewController.h
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddContentViewController.h"
@class MKMapView;

@interface GemFinderViewController : UIViewController <CLLocationManagerDelegate, AddContentViewControllerDelegate>

//Temporary mapview outlet to show nearby gems
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//Outlet for drop gem button (for enabling/disabling)
@property (weak, nonatomic) IBOutlet UIButton *dropButton;

//Outlet for pick up gem button (for enabling/disabling)
@property (weak, nonatomic) IBOutlet UIButton *pickUpButton;

//Handles pressing the drop gem button
- (IBAction)dropButtonPress:(id)sender;

//Handles pressing the pick up gem button
- (IBAction)pickUpButtonPress:(id)sender;

@end
