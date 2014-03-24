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
static NSUInteger const GemQueryLimit = 20;

// Parse API key constants:
//User Class
static NSString * const ParseUserClassName = @"User";
static NSString * const ParseUserInventoryKey = @"inventory"; //Array of pointers to gems
static NSString * const ParseUserTimelineKey = @"timeline"; //Array of pairs of pointers to gems and arrays of pointers to all relevant metadata
//Gem Class
static NSString * const ParseGemClassName = @"Gem";
static NSString * const ParseGemLocationsKey = @"location"; //Array of CLLocations
static NSString * const ParseGemCurrentLocationKey = @"currentLocation"; //PFGeopoint
static NSString * const ParseGemMetadataReferenceKey = @"metadata"; //Pointer to metadata
//Gem Metadata Class
static NSString * const ParseGemMetadataClassName = @"GemMetadata";
static NSString * const ParseMetaTextContentKey = @"textContent"; //String
static NSString * const ParseMetaPickUpDateKey = @"pickUpDate"; //Date
static NSString * const ParseMetaGemReferenceKey = @"gem"; //Pointer to gem

// Notification Names:
static NSString * const GemDroppedNotification = @"GemDroppedNotification";
static NSString * const GemPickedUpNotification = @"GemPickedUpNotification";
static NSString * const PresentLeaveGemVCNotification = @"PresentLeaveGemVCNotification";
static NSString * const GemContentDeletedNotification = @"GemContentDeletedNotification";
static NSString * const SignUpCompletedNotification = @"SignUpCompletedNotification";
static NSString * const LoginCompletedNotification = @"LoginCompletedNotification";

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BounceMenuController.h"
#import "AccountHandlerDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BounceMenuControllerDelegate, AccountHandlerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *controllers;
@property (strong, nonatomic) BounceMenuController *bounceMenuController;
@property (strong, nonatomic) UINavigationController *nav;
@property (nonatomic, strong) CLLocation *currentLocation;


-(void) viewController:(UIViewController *)controller didUserLoginSuccessfully:(BOOL)success;
-(void) viewController:(UIViewController *)controller didUserLogoutSuccessfully:(BOOL)success;
-(void) createGem:(NSUInteger)count;
@end
