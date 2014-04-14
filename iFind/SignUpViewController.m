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
    
//    if (!self.pioneerRank){
//        
//    }
    
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
}
@end
