//
//  LoginViewController.h
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountHandlerDelegate.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *createKeyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//Handles tap gestures to lower the keyboard
- (IBAction)tapAwayGesture:(id)sender;

- (IBAction)didPressLogin:(id)sender;
- (IBAction)fbLoginPress:(id)sender;
- (IBAction)createKeyPress:(id)sender;


//Account handler delegate to handle login success
@property (nonatomic, assign) id <AccountHandlerDelegate> delegate;

@end
