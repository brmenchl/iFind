//
//  LeaveGemViewController.m
//  iFind
//
//  Created by Bradley Menchl on 3/16/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "LeaveGemViewController.h"
#import "GemContentContainerView.h"
#import "UIImage+ImageEffects.h"
#import "ContentView.h"
#import "TextContentView.h"
#import "AppDelegate.h"

@interface LeaveGemViewController ()
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *unavailableButtons;
@property (nonatomic, strong) NSMutableArray *containers;
@property (nonatomic, strong) UIImageView *blurBackground;
@end

@implementation LeaveGemViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.radialMenu = [[ALRadialMenu alloc] init];
	self.radialMenu.delegate = self;
    if(!self.containers) {
        self.containers = [[NSMutableArray alloc] init];
    }
    //I PUT THIS DUMMY ELEMENT HERE BECAUSE THE IDIOT WHO MADE THE RADIAL MENU DOES 1-BASED COUNTING
    self.buttons = [[NSMutableArray alloc] initWithObjects:@"dummy", @[@"soundcloud",[UIImage imageNamed:@"soundcloud.png"]],@[@"messenger-generic",[UIImage imageNamed:@"messenger-generic.png"]], nil];
    self.unavailableButtons = [[NSMutableArray alloc] initWithCapacity:[self.buttons count]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reAddButton:) name:GemContentDeletedNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.backgroundImage setImage:self.blurImage];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.radialMenu itemsWillDisapearIntoButton:self.radialMenu];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GemContentDeletedNotification object:nil];
}

- (IBAction)addContentPress:(id)sender {
    [self.radialMenu buttonsWillAnimateFromButton:sender withFrame:self.addContentButton.frame inView:self.view];
}

- (void) reAddButton:(NSNotification *)note {
    NSLog(@"ADDING TO, %@", [note.userInfo objectForKey:@"Type"]);
    NSString *type = [note.userInfo objectForKey:@"Type"];
    for(id temp in self.unavailableButtons) {
        if ([[temp objectAtIndex:0] isEqualToString:type]) {
            [self.buttons addObject:temp];
            [self.unavailableButtons removeObject:temp];
            break;
        }
    }
}

#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
	return [self.buttons count] - 1;
}


- (NSInteger) arcSizePerButton:(ALRadialMenu *)radialMenu {
	return 45;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
	return 70;
}


- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
    return [[self.buttons objectAtIndex:index] objectAtIndex:1];
}


- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    ContentView *newContentView = nil;
    if([[[self.buttons objectAtIndex:index] objectAtIndex:0] isEqualToString:@"messenger-generic"]) {
        newContentView = [[TextContentView alloc] init];
    }
    else if([[[self.buttons objectAtIndex:index]objectAtIndex:0] isEqualToString:@"soundcloud"]) {
        
    }
    [self.unavailableButtons addObject:[self.buttons objectAtIndex:index]];
    [self.buttons removeObjectAtIndex:index];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    GemContentContainerView *newContainer = [[GemContentContainerView alloc] initWithChildView:newContentView frame:CGRectMake(0, 30, screenBounds.size.width - 30, 150) type:[[self.unavailableButtons lastObject] objectAtIndex:0]];
    [self.containers addObject:newContainer];
    [self.scrollView addSubview:newContainer];
    NSLog(@"%lu",[self.containers count]);
}

- (NSInteger) arcStartForRadialMenu:(ALRadialMenu *)radialMenu {
    return -45;
}

- (float) buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu {
    return 50;
}

- (IBAction)tapGestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)dropGemButtonPress:(id)sender {
    NSMutableArray *contentArray = [[NSMutableArray alloc] init];
    for(GemContentContainerView *container in self.containers) {
        NSLog(@"LOOPING");
        [contentArray addObject:[container.view contentData]];
    }
    NSLog(@"%lu",[contentArray count]);
    [self.delegate dropGemWithContent:contentArray];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
