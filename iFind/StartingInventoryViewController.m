//
//  StartingInventoryViewController.m
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "StartingInventoryViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>


@interface StartingInventoryViewController ()

@end

@implementation StartingInventoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CLLocation * temp_ref = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentLocation;
        
        
        
        NSDictionary *pioneerParams = @{@"latitude":[NSNumber numberWithDouble:temp_ref.coordinate.latitude],@"longitude":[NSNumber numberWithDouble:temp_ref.coordinate.longitude]};
        
        [PFCloud callFunctionInBackground:@"pioneerStatusClosestGem" withParameters:pioneerParams block:^(NSString* response, NSError* error){
            
            NSData* jsonObj = [response dataUsingEncoding:NSUTF8StringEncoding];
            
            if (!error){
                
                NSDictionary* cloudResponse = nil;
                
                NSError* localError = nil;
                cloudResponse = [NSJSONSerialization JSONObjectWithData:jsonObj options:0 error:&localError];
                NSLog(@"%@",cloudResponse);
                NSLog(@"%@",(NSNumber*)cloudResponse[@"distance"]);
                NSLog(@"%@",(NSNumber*)cloudResponse[@"pioneerRank"]);
                
                 self.distanceFromGem = [NSString stringWithFormat:@"%@",cloudResponse[@"distance"]];
                
                NSString * fuark = [NSString stringWithFormat:@"%@",cloudResponse[@"pioneerRank"]];
                
                self.pioneerRank = [fuark intValue];
                
                
            }
            
            
            
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-80, 50, 160, 60)];
    
    self.titleLabel.text = @"Your Starting Inventory";
    [self.titleLabel setFont:[UIFont fontWithName:@"Futura" size:20]];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    
    [self.view addSubview:self.titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.28 green:0.47 blue:0.29 alpha:1];
    
    
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

@end
