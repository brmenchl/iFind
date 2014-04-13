//
//  AppDelegate.h
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

static double const MaximumSearchDistance = 100.0;  //Maximum distance to look for nearby gems (meters?)
static double const DefaultStartingInventory = 5; //Default amount of gems given to a new user
static double const PickUpDistance = 100; //Maximum distance allowing user to pick up a gem (meters?)  needs to be less
static NSUInteger const GemQueryLimit = 20; //Currently limits the mapview querying for nearby gems, we might set this to 1 later

// Parse API key constants:
static NSString * const ParseObjectIDKey = @"objectId";
static NSString * const ParseCreatedAtKey = @"createdAt";

//User Class
static NSString * const ParseUserClassName = @"User";
static NSString * const ParseUserInventoryKey = @"inventory"; //Array of pointers to gems
static NSString * const ParseUserTimelineKey = @"timeline"; //Array of pairs of pointers to gems and arrays of pointers to all relevant metadata
static NSString * const ParseUserPioneerRankKey = @"pioneerRank";
static NSString * const ParseUserPioneerPointerKey = @"pioneerPointer";
static NSString * const ParseUserLocationRegisteredKey = @"locationRegistered";
//Gem Class
static NSString * const ParseGemClassName = @"Gem";
static NSString * const ParseGemLocationsKey = @"locations"; //Array of PFGeopoints
static NSString * const ParseGemCurrentLocationKey = @"currentLocation"; //PFGeopoint
static NSString * const ParseGemMetadataReferenceKey = @"metadata"; //Pointer to metadata
static NSString * const ParseGemLastOwnerKey = @"lastOwner"; //Pointer to last user carrying gem, or current user if gem is not on field
//Gem Metadata Class
static NSString * const ParseGemMetadataClassName = @"GemMetadata";
static NSString * const ParseMetaTextContentKey = @"textContent"; //Text message content
static NSString * const ParseMetaImageContentKey = @"imageContent"; //Photo content
static NSString * const ParseMetaGemReferenceKey = @"gem"; //Pointer to gem
static NSString * const ParseMetaDropLocationKey = @"dropLocation"; //PFGeopoint of dropped location
static NSString * const ParseMetaPickUpDateKey = @"pickUpDate"; //Date of metaData pick up

// Notification Names:
static NSString * const GemDroppedNotification = @"GemDroppedNotification";
static NSString * const GemPickedUpNotification = @"GemPickedUpNotification";

// Queue Names:
static NSString * const CurrentUserQueueLabel = @"currentUserQueue";

// Storyboard View Controller Names:
static NSString * const LoadingViewControllerIdentfier = @"LoadingViewController";

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BounceMenuController.h"
#import "AccountHandlerDelegate.h"
#import "LocationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BounceMenuControllerDelegate, AccountHandlerDelegate>

//Reference to the window object
@property (strong, nonatomic) UIWindow *window;

//Public reference to the bounceMenuController, which is the wrapper controller over all the main views of the app
@property (strong, nonatomic) BounceMenuController *bounceMenuController;

//Public reference to the NavigationController, which is the wrapper controller for the login and sign up screens.
//We might want to make create user a modal view controller, so we might eventually get rid of this
@property (strong, nonatomic) UINavigationController *nav;

//Public reference to the last current location grabbed by Core Location.  This should speed up some execution.
@property (nonatomic, strong) CLLocation *currentLocation;

// Queues
@property dispatch_queue_t currentUserQueue;

@property (nonatomic, strong) LocationManager* locationManager;

@end
