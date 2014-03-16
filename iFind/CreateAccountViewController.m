//
//  CreateAccountViewController.m
//  iFind
//
//  Created by Bradley Menchl on 3/11/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.usernameField.text = @"";
    self.emailField.text = @"";
    self.emailFieldAgain.text = @"";
    self.passwordField.text = @"";
    self.passwordFieldAgain.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden: NO animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldsChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    self.createLockerButton.enabled = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldsChanged:(NSNotification *)note {
    if(self.usernameField.text != nil &&
       self.emailField != nil &&
       [self.emailFieldAgain.text isEqualToString:self.emailFieldAgain.text] &&
       self.passwordField != nil &&
       [self.passwordFieldAgain.text isEqualToString:self.passwordFieldAgain.text]) {
        self.createLockerButton.enabled = YES;
    }
    else {
        self.createLockerButton.enabled = NO;
    }
}

- (IBAction)tapAwayGesture:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)createLockerPress:(id)sender {
    UIAlertView *alertView = nil;
    if([self NStringIsValidPassword:self.passwordField.text]) {
        if([self NSStringIsValidEmail:self.emailField.text]) {
            PFUser *user = [PFUser user];
            user.username = self.usernameField.text;
            user.password = self.passwordField.text;
            user.email = self.emailField.text;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    if([user.username isEqualToString: @"fuark"]) {
                        [self.delegate createGem:AdminStartingInventory];
                    }
                    else {
                        [self.delegate createGem:DefaultStartingInventory];
                    }
                    [self.delegate viewController:self didUserLoginSuccessfully:YES];
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@",errorString);
                }
            }];
        }
        else {
            alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Email" message:@"Please enter a valid email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }
    else {
        alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Password" message:@"Please enter a valid password\n(passwords must have at least 6 characters and be a mix of letters and numbers)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

-(BOOL) NStringIsValidPassword: (NSString *)checkString {
    NSString *passwordRegex = @"(?=^.{6,}$)(?=.*[0-9])(?![.\n])(?=.*[a-zA-Z]).*$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passTest evaluateWithObject:checkString];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES;
    NSString *strictFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *unstrictFilterString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? strictFilterString : unstrictFilterString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
