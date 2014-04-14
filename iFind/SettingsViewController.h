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

//handles pressing the log out button
- (IBAction)logOutPress:(id)sender;

//reference to AccountHandlerDelegate to handle log out success
@property (nonatomic, assign) id <AccountHandlerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
