//
//  AppDelegate.h
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BounceMenuController.h"
#import "WelcomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BounceMenuControllerDelegate, WelcomeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *controllers;
@property (strong, nonatomic) BounceMenuController *bounceMenuController;

-(void) welcomeViewController:(WelcomeViewController *)controller didUserLoginSuccessfully:(BOOL)success;
@end
