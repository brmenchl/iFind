//
//  AppDelegate.m
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "GemFinderViewController.h"
#import "WelcomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Parse setApplicationId:@"EXa4eSmnKSJ1Pe4KR1e6hnNMmTvbs7ExC441LLkR"
                  clientKey:@"4Cg6pBg5EUV3IAKmrpKsTLUoHMBbxoysNvL81q1x"];
    [PFFacebookUtils initializeFacebook];
    [FBLoginView class];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //Initializing bouncemenucontroller
    self.bounceMenuController = [[BounceMenuController alloc] init];
    GemFinderViewController *findervc = [sb instantiateViewControllerWithIdentifier:@"finderVC"];
    findervc.delegate = (id<GemFinderViewControllerDelegate>)self.bounceMenuController;
    SettingsViewController *settingsvc = [sb instantiateViewControllerWithIdentifier:@"settingsVC"];
    settingsvc.delegate = self;
    self.controllers = [NSArray arrayWithObjects:findervc, settingsvc, nil];
    

    self.bounceMenuController.viewControllers = self.controllers;
    self.bounceMenuController.delegate = self;
    //Initializing Login/Signup screen
    WelcomeViewController *welcomeVC = [sb instantiateViewControllerWithIdentifier:@"welcomeVC"];
    welcomeVC.delegate = self;
    self.nav = [[UINavigationController alloc] initWithRootViewController: welcomeVC];

    if([PFUser currentUser]) {
        self.window.rootViewController = self.bounceMenuController;
    }
    else {
        self.window.rootViewController = self.nav;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    [self.bounceMenuController setSelectedIndex:0];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[PFFacebookUtils session] close];
}

- (BOOL)bounceMenuController:(BounceMenuController *)controller shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)bounceMenuController:(BounceMenuController *)controller didSelectViewController:(UIViewController *)viewController {
}

- (void) viewController:(UIViewController *)controller didUserLoginSuccessfully:(BOOL)success{
    if(success) {
        [self.nav popToRootViewControllerAnimated:NO];
        self.window.rootViewController = self.bounceMenuController;
    }
}

- (void) viewController:(UIViewController *)controller didUserLogoutSuccessfully:(BOOL)success{
    if(success) {
        [self.bounceMenuController setSelectedIndex:0];
        self.window.rootViewController = self.nav;
    }
}

// TO DO:
// Gem[location]: empty array
// Gem[currentLocation]: null
// Gem[metadata]: null
// Store gem object in User[inventory] array
- (void) createGem:(NSUInteger)count {
    NSMutableArray *inventory = [[NSMutableArray alloc] init];

    for(int i = 0; i < count; i++) {
        //Creating a new Gem Parse object
        PFObject *gem = [PFObject objectWithClassName:ParseGemClassName];
        gem[ParseGemLocationsKey] = [[NSMutableArray alloc] init];
        gem[ParseGemCurrentLocationKey] = [NSNull null];
        gem[ParseGemMetadataReferenceKey] = [NSNull null];
        [inventory addObject:gem];
    }    
    [[PFUser currentUser] addObjectsFromArray:inventory forKey:ParseUserInventoryKey];
    [[PFUser currentUser] saveInBackground];
}

@end
