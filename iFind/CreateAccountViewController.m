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

- (void)viewDidAppear:(BOOL)animated   {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.usernameField.text = @"";
    self.emailField.text = @"";
    self.passwordField.text = @"";
    self.passwordFieldAgain.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden: NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
        
    UIImage *backgroundImage = [UIImage imageNamed:@"waterfall.jpg"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
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
            user[ParseUserInventoryKey] = [[NSArray alloc] init];
            user[ParseUserTimelineKey] = [[NSArray alloc] init];
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.delegate createGem:DefaultStartingInventory];
                    [self.delegate viewController:self didUserLoginSuccessfully:YES];
                } else {
                    NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
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
