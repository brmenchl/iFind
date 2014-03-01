//
//  WelcomeViewController.h
//  iFind
//
//  Created by Bradley Menchl on 2/28/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WelcomeViewController;

@protocol WelcomeViewControllerDelegate <NSObject, UITextFieldDelegate>
- (void) welcomeViewController:(WelcomeViewController *)controller didUserLoginSuccessfully:(BOOL)success;
@end

@interface WelcomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)tapGestureRecognizer:(id)sender;
- (IBAction)loginPress:(id)sender;
- (IBAction)createAccountPress:(id)sender;
- (IBAction)fbLoginPress:(id)sender;

@property (nonatomic, assign) id <WelcomeViewControllerDelegate> delegate;

@end
