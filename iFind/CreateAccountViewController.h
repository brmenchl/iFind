//
//  CreateAccountViewController.h
//  iFind
//
//  Created by Bradley Menchl on 3/11/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountHandlerDelegate.h"

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate>

//Outlet for username textfield
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

//Outlet for email textfield
@property (weak, nonatomic) IBOutlet UITextField *emailField;

//Outlet for password textfield
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

//Outlet for password repitition textfield
@property (weak, nonatomic) IBOutlet UITextField *passwordFieldAgain;

//Handles tap gestures to lower the keyboard
- (IBAction)tapAwayGesture:(id)sender;

//Handles pressing the create locker button
- (IBAction)createLockerPress:(id)sender;

//Account handler delegate property to handle successful log in
@property (nonatomic, assign) id <AccountHandlerDelegate> delegate;

@end
