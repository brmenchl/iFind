//
//  WelcomeViewController.m
//  iFind
//
//  Created by Bradley Menchl on 2/28/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "WelcomeViewController.h"
#import <Parse/Parse.h>
#import "CreateAccountViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController () {
    UIAlertView *loginErrorAlert;
    UIAlertView *forgotPasswordAlert;
}
@end

@implementation WelcomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden: YES animated:NO];

    UIImage *backgroundImage = [UIImage imageNamed:@"tower.jpg"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    self.loginButton.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.loginButton.enabled = NO;
}

- (IBAction)tapGestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)loginPress:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        if(user) {
            //Success
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
        else {
            if(error == nil) {
                loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn’t log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", @"Forgot Password", nil];
            }
            else {
                NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
                if([error code] == 101) {
                    loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",@"Forgot Password", nil];
                }
            }
            [loginErrorAlert show];
        }
    }];
    [self.activityIndicator startAnimating];
}

// Called upon dismissal of UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView == loginErrorAlert && buttonIndex == 1) {
        //OPEN PASSWORD REST PROMPT
        forgotPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message: @"Please enter the email address associated with the account and we will send you a link to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil];
        forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [forgotPasswordAlert show];
    }
    else if(alertView == forgotPasswordAlert && buttonIndex == forgotPasswordAlert.firstOtherButtonIndex) {
        //RESET PASSWORD
        [PFUser requestPasswordResetForEmailInBackground:[forgotPasswordAlert textFieldAtIndex:0].text];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"createAccountSegue"]) {
        CreateAccountViewController *vc = segue.destinationViewController;
        vc.delegate = self.delegate;
    }
}

- (IBAction)fbLoginPress:(id)sender {
    NSArray *fbPermissions = @[];
    [PFFacebookUtils logInWithPermissions:fbPermissions block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating]; // Hide loading indicator
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            }
            else {
                NSLog(@"An error occurred: %@", error);
            }
        }
        else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in");
            [self.delegate createGem:DefaultStartingInventory];
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
        else {
            NSLog(@"User with facebook logged in");
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
    }];
    [self.activityIndicator startAnimating];
}

// THIS IS APPARENTLY NOT A GREAT WAY TO MOVE SCREEN CONTENT UP AND DOWN TO AVOID THE KEYBOARD

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateViewUp: YES];
}

- (void) textFieldDidEndEditing: (UITextField *)textField {
    if(![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        self.loginButton.enabled = YES;
    }
    else {
        self.loginButton.enabled = NO;
    }
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
