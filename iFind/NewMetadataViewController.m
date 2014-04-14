//
//  NewMetadataViewController.m
//  iFind
//
//  Created by Bradley Menchl on 4/14/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "NewMetadataViewController.h"
#import "TimelineAccordianView.h"
#import "AppDelegate.h"

@interface NewMetadataViewController ()
@property (nonatomic) UIView *TerribleCodingPracticeHeader;
@end

@implementation NewMetadataViewController

- (id) initWithMetadata:(PFObject *)metadata {
    self = [super init];
    if(self) {
        self.accordianView = [[TimelineAccordianView alloc] init];
        self.view.backgroundColor = [UIColor darkGrayColor];
        self.accordianView.metadata = metadata;
        self.accordianView.delegate = self;
        self.TerribleCodingPracticeHeader = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,40)];
        self.TerribleCodingPracticeHeader.backgroundColor = [UIColor colorWithRed:0.77 green:0.65 blue:0.32 alpha:1];
        UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.TerribleCodingPracticeHeader addGestureRecognizer:recognizer];
        UILabel *label = [[UILabel alloc] initWithFrame:self.TerribleCodingPracticeHeader.frame];
        label.text = @"Close";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Futura" size:18];
        label.textColor = [UIColor colorWithRed:0.76 green:0.44 blue:0.36 alpha:1];
        [self.TerribleCodingPracticeHeader addSubview:label];
        [self.view addSubview:self.TerribleCodingPracticeHeader];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view insertSubview:self.accordianView belowSubview:self.TerribleCodingPracticeHeader];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.bounceMenuController setMenuButtonIsHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    int64_t delayInSeconds = 0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.accordianView handleTap:nil];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.bounceMenuController setMenuButtonIsHidden:NO];
}

- (void) expandView:(TimelineAccordianView *)view {
    return;
}

- (void) handleTap:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
