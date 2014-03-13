//
//  SettingsViewController.m
//  iFind
//
//  Created by Bradley Menchl on 3/1/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (IBAction)logOutPress:(id)sender {
    [PFUser logOut];
    [self.delegate viewController:self didUserLogoutSuccessfully:YES];
}

@end
