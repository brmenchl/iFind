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

@implementation CreateAccountViewController

#pragma ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Show navigation controller, make it completely transparent
    [self.navigationController setNavigationBarHidden: NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    //Set up image background for view controller
    UIImage *backgroundImage = [UIImage imageNamed:@"waterfall.jpg"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

//Clear data on view disappear to refresh view controller data (maybe put this in a separate method)
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.usernameField.text = @"";
    self.emailField.text = @"";
    self.passwordField.text = @"";
    self.passwordFieldAgain.text = @"";
}

// Hacky way to close keyboard upon tapping the view
- (IBAction)tapAwayGesture:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)createLockerPress:(id)sender {
    UIAlertView *alertView = nil;
    if([self NStringIsValidPassword:self.passwordField.text]) {
        if([self NSStringIsValidEmail:self.emailField.text]) {
            //This block is reached upon recognizing a valid password and email
            //Create a new PFUser object to sign up with
            PFUser *user = [PFUser user];
            user.username = self.usernameField.text;
            user.password = self.passwordField.text;
            user.email = self.emailField.text;
            //Initialize empty inventory and timeline arrays
            user[ParseUserInventoryKey] = [[NSArray alloc] init];
            user[ParseUserTimelineKey] = [[NSArray alloc] init];
            
            //Sign up user
            UIViewController *loadingVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loadingVC"];
            loadingVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
                if(succeeded) {
                    //Success
                    //Create gems for starting inventory and notify the delegate of a successful login
                    [self.delegate createGem:DefaultStartingInventory];
                    [self.delegate viewController:self didUserLoginSuccessfully:YES];
                }
                else {
                    //No success, we need to have error code checks here for things like:
                    // Username taken, email taken, etc..
                    NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
                }
            }];
            [self.navigationController presentViewController:loadingVC animated:YES completion:NULL];
            
        }
        else {
            //Invalid email
            alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Email" message:@"Please enter a valid email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }
    else {
        //Invalid password
        alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Password" message:@"Please enter a valid password\n(passwords must have at least 6 characters and be a mix of letters and numbers)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

//Checks that pass word is at least 6 characters long and is a mix of at least one letter and one number
// returns yes if valid password
-(BOOL) NStringIsValidPassword: (NSString *)checkString {
    NSString *passwordRegex = @"(?=^.{6,}$)(?=.*[0-9])(?![.\n])(?=.*[a-zA-Z]).*$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passTest evaluateWithObject:checkString];
}

//Checks that email is of the correct general format (some number of characters + @ + some number of characters + . + 2-4 characters
// returns yes if valid email
-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES;
    NSString *strictFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *unstrictFilterString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? strictFilterString : unstrictFilterString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


// THIS IS APPARENTLY NOT A GREAT WAY TO MOVE SCREEN CONTENT UP AND DOWN TO AVOID THE KEYBOARD

#pragma UITextFieldDelegate methods

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
