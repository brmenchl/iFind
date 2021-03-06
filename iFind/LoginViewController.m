//
//  LoginViewController.m
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface LoginViewController (){
    //AlertView for any error in login
    UIAlertView *loginErrorAlert;
    //AlertView for forgotten password information
    UIAlertView *forgotPasswordAlert;
}
@property (nonatomic) NSString *responseParentNode;
@property int pioneerRank;
@end

@implementation LoginViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0.76 green:0.44 blue:0.36 alpha:1];
    
    self.titleLabel.textColor =[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    
    [self.createKeyButton setTitleColor:[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1] forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1] forState:UIControlStateNormal];
    
    self.delegate = ((id<AccountHandlerDelegate>)[[UIApplication sharedApplication] delegate]);
    
    //[self.activityIndicator stopAnimating];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //TODO make a separate refresh method
    //Clear all fields and reset button states
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.loginButton.enabled = NO;
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

- (IBAction)didPressLogin:(id)sender {
    
    NSLog(@"didPressLogin");
    //[self.delegate viewController:self didUserLoginSuccessfully:YES];
    //Attempts to log in user with current credentials
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(appDelegate.currentUserQueue, ^{
        NSError *logInError = nil;
        [PFUser logInWithUsername:self.usernameField.text password:self.passwordField.text error:&logInError];
        //First, stop the spinner
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
        if([PFUser currentUser]) {
            //Success, tell the delegate to handle successful user log in
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate viewController:self didUserLoginSuccessfully:YES];
            });
        }
        else {
            //No success
            if(logInError == nil) {
                //Not sure if this block will ever be reached
                //set up login alertview
                loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn’t log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", @"Forgot Password", nil];
            }
            else {
                NSLog(@"%@", [[[logInError userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
                //Error code 101 is sent by parse for invalid uname/pword combo
                if([logInError code] == 101) {
                    //set up login alertview
                    loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Couldn't log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",@"Forgot Password", nil];
                }
            }
            //show login alertview
            dispatch_async(dispatch_get_main_queue(), ^{
                [loginErrorAlert show];
            });
        }
    });
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
            @synchronized([PFUser currentUser]) {
                //If this is the first time the user logged in (they created their account through facebook)
                NSLog(@"User with facebook signed up and logged in");
                CLLocation *temp_ref = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation;
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
                
                [self.activityIndicator stopAnimating];
                [self.delegate viewController:self didUserLoginSuccessfully:YES];
            }
        }
        else {
            NSLog(@"User with facebook logged in");
            [self.activityIndicator stopAnimating];
            [self.delegate viewController:self didUserLoginSuccessfully:YES];
        }
    }];
    //Immediately start loading spinner
    [self.activityIndicator startAnimating];
}

- (IBAction)createKeyPress:(id)sender {
    
    AppDelegate*temp = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    temp.window.rootViewController = [temp.sb instantiateViewControllerWithIdentifier:@"SignUp"];
}

- (IBAction)didTapView:(id)sender {
    [self.view endEditing:YES];
}
@end
