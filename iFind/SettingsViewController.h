//
//  SettingsViewController.h
//  iFind
//
//  Created by Bradley Menchl on 3/1/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountHandlerDelegate.h"

@interface SettingsViewController : UIViewController
- (IBAction)logOutPress:(id)sender;


@property (nonatomic, assign) id <AccountHandlerDelegate> delegate;

@end
