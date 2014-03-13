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
#import "CreateAccountViewController.h"
#import "SettingsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BounceMenuControllerDelegate, WelcomeViewControllerDelegate, CreateAccountViewControllerDelegate, SettingsViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *controllers;
@property (strong, nonatomic) BounceMenuController *bounceMenuController;
@property (strong, nonatomic) UINavigationController *nav;

-(void) viewController:(UIViewController *)controller didUserLoginSuccessfully:(BOOL)success;
-(void) viewController:(UIViewController *)controller didUserLogoutSuccessfully:(BOOL)success;
@end
