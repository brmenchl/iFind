//
//  WelcomeViewController.m
//  iFind
//
//  Created by Bradley Menchl on 2/28/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "WelcomeViewController.h"
#import <Parse/Parse.h>

@interface WelcomeViewController ()
@end

@implementation WelcomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden: YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    self.loginButton.enabled = NO;
    self.createAccountButton = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

// VALIDITY CHECKS
- (void)textFieldsChanged:(NSNotification *)note {
    if(self.usernameField.text != nil &&
       self.usernameField.text.length > 6 &&
       self.passwordField.text != nil &&
       self.passwordField.text.length > 6) {
        self.loginButton.enabled = YES;
        self.createAccountButton.enabled = YES;
    }
    else {
        self.loginButton.enabled = NO;
        self.createAccountButton.enabled = NO;
    }
}

- (IBAction)tapGestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)loginPress:(id)sender {
    NSLog(@"HI");
}

- (IBAction)createAccountPress:(id)sender {
    NSLog(@"HI");
}

- (IBAction)fbLoginPress:(id)sender {
    NSArray *fbPermissions = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    [PFFacebookUtils logInWithPermissions:fbPermissions block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating]; // Hide loading indicator
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
            else {
                NSLog(@"An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        }
        else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in");
            [self.delegate welcomeViewController:self didUserLoginSuccessfully:YES];
        }
        else {
            NSLog(@"User with facebook logged in");
            [self.delegate welcomeViewController:self didUserLoginSuccessfully:YES];
        }
    }];
    [self.activityIndicator startAnimating];
}

// THIS IS APPARENTLY NOT A GREAT WAY TO MOVE SCREEN CONTENT UP AND DOWN TO AVOID THE KEYBOARD

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateViewUp: YES];
}

- (void) textFieldDidEndEditing: (UITextField *)textField {
    [self animateViewUp: NO];
}

- (void) animateViewUp: (BOOL) up
{
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
