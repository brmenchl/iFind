//
//  AppDelegate.m
//  iFind
//
//  Created by Andrew Milenius on 2/25/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Parse setApplicationId:@"EXa4eSmnKSJ1Pe4KR1e6hnNMmTvbs7ExC441LLkR"
                  clientKey:@"4Cg6pBg5EUV3IAKmrpKsTLUoHMBbxoysNvL81q1x"];
    [PFFacebookUtils initializeFacebook];
    [FBLoginView class];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *findervc = [sb instantiateViewControllerWithIdentifier:@"finderVC"];
    UIViewController *settingsvc = [sb instantiateViewControllerWithIdentifier:@"settingsVC"];
    self.controllers = [NSArray arrayWithObjects:findervc, settingsvc, nil];
    self.bounceMenuController = [[BounceMenuController alloc] init];
    self.bounceMenuController.viewControllers = self.controllers;
    self.bounceMenuController.delegate = self;

    if([PFUser currentUser]) {
        self.window.rootViewController = self.bounceMenuController;
    }
    else {
        WelcomeViewController *welcomeVC = [sb instantiateViewControllerWithIdentifier:@"welcomeVC"];
        welcomeVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: welcomeVC];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PFFacebookUtils session] close];
}

- (BOOL)bounceMenuController:(BounceMenuController *)controller shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)bounceMenuController:(BounceMenuController *)controller didSelectViewController:(UIViewController *)viewController {
    NSLog(@"selected view controller: %@", viewController);
}

- (void) welcomeViewController:(WelcomeViewController *)controller didUserLoginSuccessfully:(BOOL)success {
    if(success) {
        self.window.rootViewController = self.bounceMenuController;
    }
}

@end
