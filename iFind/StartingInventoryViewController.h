//
//  StartingInventoryViewController.h
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartingInventoryViewController : UIViewController

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* closestGemTitle;
@property (nonatomic, strong) UILabel* distanceLabel;

@property NSString * distanceFromGem;
@property int pioneerRank;

-(id) initWithParams: (NSString*)responseDistance responseRank:(NSInteger)responseRank;
@end
