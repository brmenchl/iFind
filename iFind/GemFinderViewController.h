//
//  GemFinderViewController.h
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface GemFinderViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *dropButton;
@property (weak, nonatomic) IBOutlet UIButton *pickupButton;

- (IBAction)dropButtonPress:(id)sender;
- (IBAction)pickupButtonPress:(id)sender;

@end
