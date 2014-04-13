//
//  IntroPageViewController.h
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroPageViewController : UIViewController<UIPageViewControllerDataSource>


@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, strong) NSString* responseDistance;
@property NSInteger responseRank;


@end
