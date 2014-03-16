//
//  AppDelegate.h
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

static double const MaximumSearchDistance = 100.0;
static double const DefaultStartingInventory = 5;
static double const PickUpDistance = 100;
// Parse API key constants:
static NSString * const ParseLastOwnerKey = @"lastOwner";
static NSString * const ParseDroppedKey = @"dropped";
static NSString * const ParseUsernameKey = @"username";
static NSString * const ParseLocationKey = @"location";
static NSString * const ParseInventoryCountKey = @"gemInventoryCount";
static NSString * const ParseGemName = @"Gem";
static NSUInteger const ParseGemQueryLimit = 20;

// Notification Names:
static NSString * const GemDroppedNotification = @"GemDroppedNotification";
static NSString * const GemPickedUpNotification = @"GemPickedUpNotification";

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
-(void) createGem:(NSUInteger)count;
@end
