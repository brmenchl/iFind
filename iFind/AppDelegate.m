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
#import "IntroPageViewController.h"

@interface AppDelegate()

//Array of all view controller that bouncemenucontroller keeps (all main app views other than welcome views)
//Might not be relevant, we could remove it and use a temp ivar.
@property (strong, nonatomic) NSArray *controllers;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //Setting global window reference, initializing window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Initializing the app with parse and facebook
    [Parse setApplicationId:@"EXa4eSmnKSJ1Pe4KR1e6hnNMmTvbs7ExC441LLkR"
                  clientKey:@"4Cg6pBg5EUV3IAKmrpKsTLUoHMBbxoysNvL81q1x"];
    [PFFacebookUtils initializeFacebook];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //Initializing bouncemenucontroller and all sub-controllers, they are kept in the
    self.bounceMenuController = [[BounceMenuController alloc] init];
    GemFinderViewController *findervc = [sb instantiateViewControllerWithIdentifier:@"finderVC"];
    SettingsViewController *settingsvc = [sb instantiateViewControllerWithIdentifier:@"settingsVC"];
    //Setting the settings view controller delegate to the app delegate to handle log outs.  Might want to create a separate delegate to handle this
    //Because you can only have one delegate on at a time.
    settingsvc.delegate = self;
    self.controllers = [NSArray arrayWithObjects:findervc, settingsvc, nil];
    self.bounceMenuController.viewControllers = self.controllers;
    self.bounceMenuController.delegate = self;
    
    //Initializing Login/Signup screen
    WelcomeViewController *welcomeVC = [sb instantiateViewControllerWithIdentifier:@"welcomeVC"];
    welcomeVC.delegate = self;
    //initializing the navigation controller for the welcome controllers
    self.nav = [[UINavigationController alloc] initWithRootViewController: welcomeVC];

    //Check whether a user is currently logged in. If so, go straight to the bounce menu, if not, go to the welcome screen
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    pageControl.backgroundColor = [UIColor colorWithRed:0.28 green:0.47 blue:0.29 alpha:1];
    
    IntroPageViewController * temp = [[IntroPageViewController alloc] init];
    
    
    //Location Services.
    
    self.locationManager = [[LocationManager alloc] init];
    
    
    
    
    if([PFUser currentUser]) {
        [[PFUser currentUser] refresh];
    }
    if([PFUser currentUser]) {
        self.window.rootViewController = self.bounceMenuController;
    }
    else {
        self.window.rootViewController = self.nav;
    }
    
    //self.window.rootViewController = temp;
    
    self.currentUserQueue = dispatch_queue_create([CurrentUserQueueLabel cStringUsingEncoding:NSUTF8StringEncoding], NULL);
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    //Set the current main screen to the gem finder controller
    if(self.bounceMenuController.selectedIndex != 1) {
        [self.bounceMenuController setSelectedIndex:0];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //Required for facebook+parse
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //Required for facebook+parse
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //Required for facebook+parse
    [[PFFacebookUtils session] close];
}

- (void)dealloc {
    self.currentUserQueue = nil;
}

#pragma BounceMenuControllerDelegate methods
- (BOOL)bounceMenuController:(BounceMenuController *)controller shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)bounceMenuController:(BounceMenuController *)controller didSelectViewController:(UIViewController *)viewController {
    //Nothing here yet, nothing is required yet.
    //Placed here to satisfy compiler.
}


#pragma AccountHandlerDelegate methods
- (void) viewController:(UIViewController *)controller didUserLoginSuccessfully:(BOOL)success{
    //
    if(success) {
        //Reset bounce menu to login screen if on create account screen.
        [self.nav popToRootViewControllerAnimated:NO];
        self.window.rootViewController = self.bounceMenuController;
    }
}

- (void) viewController:(UIViewController *)controller didUserLogoutSuccessfully:(BOOL)success{
    if(success) {
        //Reset bounce menu to gem finder screen.
        [self.bounceMenuController setSelectedIndex:0];
        self.window.rootViewController = self.nav;
    }
}


/*
 *  Creates <count> Parse gem objects, storing all in an NSMutableArray.
 *  The current user object then adds this array to the end of its inventory array
 *  The user is saved to Parse, and the gems are saved as a by-product
 *  Gem objects are initialized with fields: locations = empty array, currentlocation = null,
 *      metadata = null, currentOwner = current logged in user.
 */
- (void) createGem:(NSUInteger)count {
    NSLog(@"creating gems");
    @synchronized([PFUser currentUser]) {
        NSMutableArray *inventory = [[NSMutableArray alloc] init];
        for(int i = 0; i < count; i++) {
            NSLog(@"loop %i", i);
            //Creating a new Gem Parse object
            PFObject *gem = [PFObject objectWithClassName:ParseGemClassName];
            gem[ParseGemLocationsKey] = [[NSMutableArray alloc] init];
            gem[ParseGemCurrentLocationKey] = [NSNull null];
            gem[ParseGemMetadataReferenceKey] = [NSNull null];
            gem[ParseGemCurrentOwnerKey] = [PFUser currentUser];
            [inventory addObject:gem];
            [[PFUser currentUser] addObject:gem forKey:ParseUserInventoryKey];
        }
        dispatch_async(self.currentUserQueue, ^{
            [PFObject saveAll:inventory];
            [[PFUser currentUser] save];
            NSLog(@"save complete");
        });
    }
}

@end
