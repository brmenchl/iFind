//
//  SignUpViewController.m
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>



@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-60, 25, 120, 60)];
    
    self.titleLabel.text = @"Create a Locker Key";
    [self.titleLabel setFont:[UIFont fontWithName:@"Futura" size:20]];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    
    [self.view addSubview:self.titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.28 green:0.47 blue:0.29 alpha:1];
    
    [self.createButton setTitleColor:[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1] forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1] forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1] forState:UIControlStateNormal];
    
    self.delegate = ((id<AccountHandlerDelegate>)[[UIApplication sharedApplication] delegate]);
    
    if (!self.pioneerRank){
        
         CLLocation * temp_ref = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation;
        
        NSDictionary *pioneerParams = @{@"latitude":[NSNumber numberWithDouble:temp_ref.coordinate.latitude],@"longitude":[NSNumber numberWithDouble:temp_ref.coordinate.longitude]};
        
        NSError* error = nil;
        NSString* response = [PFCloud callFunction:@"pioneerStatusClosestGem" withParameters:pioneerParams error:&error];
        
        NSData* jsonObj = [response dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!error){
            
            NSDictionary* cloudResponse = nil;
            
            NSError* localError = nil;
            cloudResponse = [NSJSONSerialization JSONObjectWithData:jsonObj options:0 error:&localError];
            NSLog(@"%@",cloudResponse);
            NSLog(@"%@",(NSNumber*)cloudResponse[@"distance"]);
            NSLog(@"%@",(NSNumber*)cloudResponse[@"pioneerRank"]);
            
            self.responseParentNode = [NSString stringWithFormat:@"%@",cloudResponse[@"parentNode"]];
            
            NSString * fuark = [NSString stringWithFormat:@"%@",cloudResponse[@"pioneerRank"]];
            
            self.pioneerRank = [fuark intValue];
        }
        
        NSLog(@"pioneerRank: %i",self.pioneerRank);
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
            user[ParseUserPioneerRankKey] = [NSNumber numberWithInt:self.pioneerRank];
            PFGeoPoint * temp_loc = [PFGeoPoint geoPointWithLocation:((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation];
            user[ParseUserLocationRegisteredKey] = temp_loc;
            
            
            //Sign up user
//            UIViewController *loadingVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loadingVC"];
//            loadingVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
//                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
                if(succeeded) {
                    //Success
                    //Create gems for starting inventory and notify the delegate of a successful login
                    NSUInteger gemCount = 5;
                    
                    if (self.pioneerRank == 1){
                        gemCount = 25;
                    }
                    else if (self.pioneerRank == 2){
                        gemCount = 20;
                    }
                    else if (self.pioneerRank == 3){
                        gemCount = 15;
                    }
                    else if (self.pioneerRank == 4){
                        gemCount = 10;
                    }
                    
                    [self.delegate createGem:gemCount];
                    
                    
                    if (self.pioneerRank < 5){
                        NSDictionary * update_dict = @{@"curUser":[PFUser currentUser].objectId,@"prevNode":self.responseParentNode};
                        
                        [PFCloud callFunctionInBackground:@"updatePioneerList" withParameters:update_dict block:nil];
                    }
                    
                    [self.delegate viewController:self didUserLoginSuccessfully:YES];
                }
                else {
                    //No success, we need to have error code checks here for things like:
                    // Username taken, email taken, etc..
                    NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
                }
            }];
//            [self.navigationController presentViewController:loadingVC animated:YES completion:NULL];
            
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

- (IBAction)didPressSkip:(id)sender {
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Anonymous login failed.");
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
        }
        else {
            NSLog(@"Anonymous user logged in.");
            
            NSUInteger gemCount = 5;
            
            if (self.pioneerRank == 1){
                gemCount = 25;
            }
            else if (self.pioneerRank == 2){
                gemCount = 20;
            }
            else if (self.pioneerRank == 3){
                gemCount = 15;
            }
            else if (self.pioneerRank == 4){
                gemCount = 10;
            }
            
            [self.delegate createGem:gemCount];
            
            
            if (self.pioneerRank < 5){
                NSDictionary * update_dict = @{@"curUser":[PFUser currentUser].objectId,@"prevNode":self.responseParentNode};
                
                [PFCloud callFunctionInBackground:@"updatePioneerList" withParameters:update_dict block:nil];
            }
            
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
    }];
}

- (IBAction)didPressFb:(id)sender {
    
    //Empty array for permissions required from facebook, we can change this later if we want info
    NSArray *fbPermissions = @[];
    //Attempt to log in through facebook (either brings up facebook.com or the facebook app to authenticate)
    [PFFacebookUtils logInWithPermissions:fbPermissions block:^(PFUser *user, NSError *error) {
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
            @synchronized([PFUser currentUser]) {
                //If this is the first time the user logged in (they created their account through facebook)
                NSLog(@"User with facebook signed up and logged in");
                
                NSUInteger gemCount = 5;
                
                if (self.pioneerRank == 1){
                    gemCount = 25;
                }
                else if (self.pioneerRank == 2){
                    gemCount = 20;
                }
                else if (self.pioneerRank == 3){
                    gemCount = 15;
                }
                else if (self.pioneerRank == 4){
                    gemCount = 10;
                }
                
                [self.delegate createGem:gemCount];
                
                
                if (self.pioneerRank < 5){
                    NSDictionary * update_dict = @{@"curUser":[PFUser currentUser].objectId,@"prevNode":self.responseParentNode};
                    
                    [PFCloud callFunctionInBackground:@"updatePioneerList" withParameters:update_dict block:nil];
                }
                
                [self.delegate viewController:self didUserLoginSuccessfully:YES];
            }
        }
        else {
            NSLog(@"User with facebook logged in");
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
    }];
}
@end
