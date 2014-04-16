//
//  SignUpViewController.h
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountHandlerDelegate.h"

@interface SignUpViewController : UIViewController

@property (strong, nonatomic) UILabel* titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFieldAgain;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property int pioneerRank;
@property (nonatomic, strong) NSString * responseParentNode;

//Account handler delegate property to handle successful log in
@property (nonatomic, assign) id <AccountHandlerDelegate> delegate;

- (IBAction)didPressLoginWithKey:(id)sender;
- (IBAction)createLockerPress:(id)sender;
- (IBAction)didPressSkip:(id)sender;
- (IBAction)didPressFb:(id)sender;

@end
