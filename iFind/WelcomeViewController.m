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
    //Private properties
    
    //AlertView for any error in login
    UIAlertView *loginErrorAlert;
    //AlertView for forgotten password information
    UIAlertView *forgotPasswordAlert;
}
@end

@implementation WelcomeViewController

#pragma ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //Hide top navigation bar
    [self.navigationController setNavigationBarHidden: YES animated:NO];
    
    //Set background image for welcome screen
    UIImage *backgroundImage = [UIImage imageNamed:@"tower.jpg"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    //Create back button for welcome view controller
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    //Start with login button disabled
    self.loginButton.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //TODO make a separate refresh method
    //Clear all fields and reset button states
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.loginButton.enabled = NO;
}

- (IBAction)tapGestureRecognizer:(id)sender {
    //Hacky way to stop editing mode and remove keyboard upon view tap
    [self.view endEditing:YES];
}

- (IBAction)loginPress:(id)sender {
    //Attempts to log in user with current credentials
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        //First, stop the spinner
        [self.activityIndicator stopAnimating];
        if(user) {
            //Success, tell the delegate to handle successful user log in
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
        else {
            //No success
            if(error == nil) {
                //Not sure if this block will ever be reached
                //set up login alertview
                loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn’t log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", @"Forgot Password", nil];
            }
            else {
                NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
                //Error code 101 is sent by parse for invalid uname/pword combo
                if([error code] == 101) {
                    //set up login alertview
                    loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",@"Forgot Password", nil];
                }
            }
            //show login alertview
            [loginErrorAlert show];
        }
    }];
    //Immediately start loading spinner
    [self.activityIndicator startAnimating];
}

- (IBAction)fbLoginPress:(id)sender {
    //Empty array for permissions required from facebook, we can change this later if we want info
    NSArray *fbPermissions = @[];
    //Attempt to log in through facebook (either brings up facebook.com or the facebook app to authenticate)
    [PFFacebookUtils logInWithPermissions:fbPermissions block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating]; // Hide loading indicator
        if (!user) {
            //Login was unsuccessful
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            }
            else {
                NSLog(@"An error occurred: %@", error);
            }
        }
        else if (user.isNew) {
            //If this is the first time the user logged in (they created their account through facebook)
            NSLog(@"User with facebook signed up and logged in");
            PFUser * user = [PFUser currentUser];
            user[ParseUserInventoryKey] = [[NSArray alloc] init];
            user[ParseUserTimelineKey] = [[NSArray alloc] init];
            [user saveInBackground];
            [self.delegate createGem:DefaultStartingInventory];
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
        else {
            NSLog(@"User with facebook logged in");
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
    }];
    //Immediately start loading spinner
    [self.activityIndicator startAnimating];
}

#pragma UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //if they hit the 'forgot' button on the login alertview
    if(alertView == loginErrorAlert && buttonIndex == 1) {
        //set up forgotten password alertview
        forgotPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message: @"Please enter the email address associated with the account and we will send you a link to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil];
        forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [forgotPasswordAlert show];
    }
    //if they hit 'reset' button on the forgotten password alertview
    else if(alertView == forgotPasswordAlert && buttonIndex == forgotPasswordAlert.firstOtherButtonIndex) {
        //Ask parse to sent password reset email (haven't tried with an invalid email)
        //This will send an email to the email with a web link to parse.com where they can reset their password
        [PFUser requestPasswordResetForEmailInBackground:[forgotPasswordAlert textFieldAtIndex:0].text];
    }
}

//Sent when the login screen is about to change to the create account screen
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"createAccountSegue"]) {
        CreateAccountViewController *vc = segue.destinationViewController;
        //set the delegate of create account view controller to current delegate (appdelegate)
        //This is for the accounthandlerdelegate to handle login/logout.
        vc.delegate = self.delegate;
    }
}



// THIS IS APPARENTLY NOT A GREAT WAY TO MOVE SCREEN CONTENT UP AND DOWN TO AVOID THE KEYBOARD

#pragma UITextFieldDelegate methods

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


// Moves the entire screen upwards to make way for the keyboard when it appears/disappears
// @param up true if shifting view up, false if shifting view down.s
- (void) animateViewUp: (BOOL) up {
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
