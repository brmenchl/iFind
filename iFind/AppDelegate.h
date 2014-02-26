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

@interface AppDelegate : UIResponder <UIApplicationDelegate, BounceMenuControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
