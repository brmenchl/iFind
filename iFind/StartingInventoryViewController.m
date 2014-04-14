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
        
          
    }
    return self;
}

-(id) initWithParams: (NSString*)responseDistance responseRank:(NSInteger)responseRank{
    
    self = [super init];
    
    if (self){
        self.distanceFromGem = responseDistance;
        self.pioneerRank = (int)responseRank;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize main = self.view.frame.size;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((main.width/2)-80, 25, 160, 60)];
    self.titleLabel.text = @"Your Starting Inventory";
    self.titleLabel = [self formatUILabel:self.titleLabel font_size:20 line_count:2 text_align:NSTextAlignmentCenter];
    [self.view addSubview:self.titleLabel];
    
    self.closestGemTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, main.height-180, main.width/2, 50)];
    self.closestGemTitle.text = @"Distance from nearest Geode is:";
    self.closestGemTitle = [self formatUILabel:self.closestGemTitle font_size:18 line_count:2 text_align:NSTextAlignmentLeft];
    [self.view addSubview:self.closestGemTitle];
    
    NSString *distanceStuff = [[NSString alloc] initWithFormat:@"%@ miles",self.distanceFromGem];
    
    NSMutableAttributedString* tempStr = [[NSMutableAttributedString alloc] initWithString:distanceStuff];
    
    int x = (int)[tempStr length];
    
    [tempStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:17] range:NSMakeRange(x-6, 6)];
    [tempStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Futura" size:60] range:NSMakeRange(0, x-6)];
    
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, main.height-120, main.width-40, 60)];
    self.distanceLabel.attributedText = tempStr;
    self.distanceLabel.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    //self.distanceLabel.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.distanceLabel];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.28 green:0.47 blue:0.29 alpha:1];
    
    
}

- (UILabel*) formatUILabel: (UILabel*)target font_size:(CGFloat)font_size line_count:(NSInteger) line_count text_align: (NSTextAlignment) text_align
{
    [target setFont:[UIFont fontWithName:@"Futura" size:font_size]];
    
    target.lineBreakMode = NSLineBreakByWordWrapping;
    target.numberOfLines = line_count;
    target.textAlignment = text_align;
    
    target.textColor = [UIColor colorWithRed:0.91 green:0.68 blue:0.05 alpha:1];
    
    return target;
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
