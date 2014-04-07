//
//  WelcomeViewController.h
//  iFind
//
//  Created by Bradley Menchl on 2/28/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountHandlerDelegate.h"
@interface WelcomeViewController : UIViewController

//Outlet for username textfield
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
//Outlet for password textfield
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
//Outlet for log in button (for disabling purposes, might be irrelevant)
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//Outlet for create account button (for disabling purposes, might be irrelevant)
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
//Outlet for 'log in through facebook' button (for disabling purposes, might be irrelevant)
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
//Outlet for loading spinner (to show and hide)
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//Handles user tap gesture to remove keyboard, kinda messy way to do it..
- (IBAction)tapGestureRecognizer:(id)sender;
//Handles pressing the log in button
- (IBAction)loginPress:(id)sender;
//Handles pressing the facebook log in button
- (IBAction)fbLoginPress:(id)sender;
- (IBAction)SkipLoginPress:(id)sender;

//Account handler delegate to handle login success
@property (nonatomic, assign) id <AccountHandlerDelegate> delegate;

@end
