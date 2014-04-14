//
//  HowToUseViewController.m
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "HowToUseViewController.h"
#import "AppDelegate.h"


@interface HowToUseViewController ()

@end

@implementation HowToUseViewController

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
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-60, 30, 120, 30)];
    
    self.titleLabel.text = @"How To Use";
    [self.titleLabel setFont:[UIFont fontWithName:@"Futura" size:20]];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    
    self.label0.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.label1.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.label2.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.label3.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.label4.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    
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
