//
//  SettingsViewController.h
//  iFind
//
//  Created by Bradley Menchl on 3/1/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>
-(void) viewController:(UIViewController *)controller didUserLogoutSuccessfully:(BOOL)success;
@end

@interface SettingsViewController : UIViewController
- (IBAction)logOutPress:(id)sender;


@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;

@end
