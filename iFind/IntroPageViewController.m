//
//  IntroPageViewController.m
//  iFind
//
//  Created by Andrew Milenius on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "IntroPageViewController.h"
#import "WelcomeGoGeoViewController.h"
#import "HowToUseViewController.h"
#import "StartingInventoryViewController.h"
#import "SignUpViewController.h"

#define MAX_PAGES 4

@interface IntroPageViewController ()

@end

@implementation IntroPageViewController

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
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    WelcomeGoGeoViewController* firstController = [[WelcomeGoGeoViewController alloc] init];
    NSArray *viewControllerArr = [NSArray arrayWithObject:firstController];
    
    [self.pageController setViewControllers:viewControllerArr direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.pageController willMoveToParentViewController:self];
    
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageController.view];
    
    [self.pageController didMoveToParentViewController:self];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[WelcomeGoGeoViewController class]]){
        
        return nil;
    }
    else if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[HowToUseViewController class]]){
        return [self viewControllerAtIndex:0];
    }
    else if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[StartingInventoryViewController class]])
    {
        return [self viewControllerAtIndex:1];
    }
    else if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[SignUpViewController class]])
    {
        return [self viewControllerAtIndex:2];
    }
    
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[WelcomeGoGeoViewController class]]){
        
        return [self viewControllerAtIndex:1];
    }
    else if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[HowToUseViewController class]]){
        return [self viewControllerAtIndex:2];
    }
    else if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[StartingInventoryViewController class]])
    {
        return [self viewControllerAtIndex:3];
    }
    else if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[SignUpViewController class]])
    {
        return nil;
    }
    
    return nil;
}

- (UIViewController *)viewControllerAtIndex:(int)i {
    // Asking for a page that is out of bounds??
    
    if (i == 0){
        WelcomeGoGeoViewController* WelcomeGoGeoController=[[WelcomeGoGeoViewController alloc] init];
        return WelcomeGoGeoController;
    }
    else if (i == 1){
        HowToUseViewController* HowToUseController = [[HowToUseViewController alloc] init];
        return HowToUseController;
    }
    else if (i == 2){
        StartingInventoryViewController * StartingInventoryController = [[StartingInventoryViewController alloc] init];
        return StartingInventoryController;
        
    }
    else if (i == 3){
        SignUpViewController * SignUpController = [[SignUpViewController alloc] init];
        return SignUpController;
    }
    
    
    return nil;
}


- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[WelcomeGoGeoViewController class]]){
        return 0;
    }
    else if ([[pageViewController.viewControllers objectAtIndex:0] isKindOfClass:[HowToUseViewController class]]){
        return 1;
    }
    
    return 0;
}

// MAX_PAGES is the total # of pages.

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return MAX_PAGES;
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
