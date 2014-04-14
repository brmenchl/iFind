//
//  GGCompassViewController.h
//  iFind
//
//  Created by Andrew Milenius on 4/11/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "GGAddContentViewController.h"



@interface GGCompassViewController : UIViewController<GGAddContentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *compassImage;
@property (weak, nonatomic) IBOutlet UILabel *distanceTitle;
@property (weak, nonatomic) IBOutlet UIButton *dropButton;
@property (weak, nonatomic) IBOutlet UIButton *pickUpButton;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UIView *withinRangeView;
@property (weak, nonatomic) IBOutlet UILabel *withinRangeLabel;

- (IBAction)didTapDropButton:(id)sender;
- (IBAction)didTapPickUpButton:(id)sender;

@end
