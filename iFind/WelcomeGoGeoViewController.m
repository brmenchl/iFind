//
//  WelcomeGoGeoViewController.m
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "WelcomeGoGeoViewController.h"
#import "AppDelegate.h"


@interface WelcomeGoGeoViewController ()

@end

@implementation WelcomeGoGeoViewController

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
    // Do any additional setup after loading the view from its nib.
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-80, 25, 160, 60)];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.text = @"Hello Explorer";
    
    self.titleLabel.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    [self.titleLabel setFont:[UIFont fontWithName:@"Futura" size:20]];
    
    self.label0.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.label1.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.label2.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.label3.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    
    [self.view addSubview:self.titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.28 green:0.47 blue:0.29 alpha:1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
