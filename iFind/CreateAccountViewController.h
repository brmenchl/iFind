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

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFieldAgain;

- (IBAction)tapAwayGesture:(id)sender;
- (IBAction)createLockerPress:(id)sender;

@property (nonatomic, assign) id <AccountHandlerDelegate> delegate;

@end
