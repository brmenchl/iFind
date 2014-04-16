//
//  GGAddContentViewController.m
//  iFind
//
//  Created by Bradley Menchl on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GGAddContentViewController.h"
#import "TextContentView.h"
#import "ImageContentView.h"
#import "SoundcloudContentView.h"

@interface GGAddContentViewController () {
    CGPoint lastLocation;
}
@property NSMutableArray *currentContentViews;
//Private property for the animated button menu, centered on the addcontentbutton
@property (nonatomic) UIButton *addContentButton;
@property (nonatomic) ALRadialMenu *radialMenu;
@property (nonatomic) NSMutableArray *unusedContentViews;
//UIImagePickerController to allow camera photo selection
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (assign, nonatomic) CATransform3D initialTransform;
@end

@implementation GGAddContentViewController

static CGFloat const ROW_MARGINS = 50;
static CGFloat const BUTTON_SIZE = 30 + ROW_MARGINS;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialize radialMenu
    self.radialMenu = [[ALRadialMenu alloc] init];
	self.radialMenu.delegate = self;
    
    lastLocation = CGPointZero;
    
    self.totalViewHeight = BUTTON_SIZE;
    self.addContentView.dataSource = self;
    self.addContentView.delegate = self;
    [self.addContentView setRecycleCells:NO];
    if(!self.addContentButton) {
        NSLog(@"here");
        self.addContentButton = [[UIButton alloc] init];
        [self.addContentButton setImage:[UIImage imageNamed:@"plusButton.png"] forState:UIControlStateNormal];
        [self.addContentButton addTarget:self action:@selector(addContentPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.addContentView addExtraView:self.addContentButton];
    }
    [self.addContentView registerClassForSubViews:[ContentView class]];
    
    //Initialize the unused and current content view arrays
    //I PUT THIS DUMMY ELEMENT HERE BECAUSE THE GUY WHO MADE THE RADIAL MENU DOES 1-BASED COUNTING
    self.unusedContentViews = [[NSMutableArray alloc] initWithObjects:@"dummy", [[TextContentView alloc] init],
                               [[ImageContentView alloc] init],
                               [[SoundcloudContentView alloc] init], nil];
    for(int index = 1; index < [self.unusedContentViews count]; index++) {
        [self.unusedContentViews[index] setDelegate:self];
    }
    self.currentContentViews = [[NSMutableArray alloc] init];
    
    //Initialize imagePicker
    self.imagePickerController = [[UIImagePickerController alloc] init];
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, -[UIScreen mainScreen].bounds.size.width, 0, 0.0);
    self.initialTransform = transform;
    
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Reset blurred background
    [self.backgroundImage setImage:self.blurImage];
    [self.addContentView reloadData];
}

//This method runs through all subviews and resets their data to allow for a new gem to be dropped
-(void) clearAllData {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    self.totalViewHeight = 0;
    //Replace all contentViews in unusedContentViews
    [self.unusedContentViews addObjectsFromArray:self.currentContentViews];
    [self.currentContentViews removeAllObjects];
    
    //Clear data from every contentView
    for(int i = 1; i < [self.unusedContentViews count]; i++) {
        [self.unusedContentViews[i] clearData];
    }
    for (UIView *cell in [self.addContentView cellSubviews]) {
        [cell removeFromSuperview];
    }
}


- (NSInteger) numberOfRows {
    return [self.currentContentViews count];
}

- (NSInteger) rowMargins {
    return ROW_MARGINS;
}

- (ContentView *) cellForRow:(NSInteger) row {
    ContentView* cell = [self.currentContentViews objectAtIndex:row];
    cell.delegate = self;
    return cell;
}

//Handles pressing the add content button
- (void)addContentPress:(UIButton *)sender {
    if(self.addContentButton.frame.origin.y > (self.addContentView.scrollView.contentOffset.y + self.addContentView.bounds.size.height - [self expandedButtonSpace])) {
        [self.addContentView.scrollView setContentOffset:CGPointMake(0, self.addContentButton.frame.origin.y - (self.addContentView.bounds.size.height - [self expandedButtonSpace])) animated:YES];
    }
    [self.radialMenu buttonsWillAnimateFromButton:sender withFrame:[sender convertRect:sender.bounds toView:self.view] inView:self.view];
}

- (NSInteger) expandedButtonSpace {
    return [self arcRadiusForRadialMenu:self.radialMenu] + [self buttonSizeForRadialMenu:self.radialMenu] + 30;
}

#pragma mark - radial menu delegate methods

- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
    //Minus 1 because of the dummy element I added..
	return [self.unusedContentViews count] - 1;
}

- (NSInteger) arcSizePerButton:(ALRadialMenu *)radialMenu {
	return 45;
}

- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
	return 70;
}

- (NSInteger) arcStartForRadialMenu:(ALRadialMenu *)radialMenu {
    return 45;
}

- (float) buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu {
    return 30;
}

- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
    //Get button image from each unused content view
    return [[self.unusedContentViews objectAtIndex:index] buttonImage];
}

//Handles user pushing any content button
//Gets relevant contentView from the unusedContentViews array and adds it to the table view
- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
    ContentView *contentView = self.unusedContentViews[index];
    if([contentView isKindOfClass:[ImageContentView class]]) {
        //If Camera is not available on the device (just in case i guess)
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                           message:@"Unable to find a camera on your device."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
            return;
        }
        else {
            self.imagePickerController.delegate = (ImageContentView *)contentView;
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:NULL];
        }
    }
    else {
        [self addAndAnimateForView:contentView];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    [self.view endEditing:YES];
}


- (IBAction)dropGemPress:(id)sender {
    NSMutableArray *dataForGem = [[NSMutableArray alloc] init];
    
    //Loop through every contentView and get it's content
    for(ContentView *content in self.currentContentViews) {
        [dataForGem addObject:[content contentData]];
    }
    
    //Notify delegate that gem is ready to be dropped, dismiss the view, and clear all data in the view
    [self.delegate dropGemWithContent:dataForGem];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self clearAllData];
}

- (IBAction)cancelPress:(id)sender {
    //Dismiss the view and clear all data in the view
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self clearAllData];
}

- (void)animateDownward:(CGFloat)distance {
    [UIView animateWithDuration:0.3
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.addContentButton.frame = CGRectOffset(self.addContentButton.frame, 0, ROW_MARGINS + distance);
                     }
                     completion:NULL
     ];
}

-(void)addAndAnimateForView:(UIView *)view {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    view.layer.transform = self.initialTransform;
    self.totalViewHeight += (ROW_MARGINS + view.frame.size.height);
    [self animateDownward:view.frame.size.height];
    [self.unusedContentViews removeObject:view];
    [self.currentContentViews addObject:view];
    [self.addContentView reloadData];
}

- (void) scrollViewBeginDragging {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
}

- (void) contentViewWillBeDeleted:(ContentView *)view {
    float delay = 0.0f;
    [self.unusedContentViews addObject:view];
    [self.currentContentViews removeObject:view];
    self.totalViewHeight -= (ROW_MARGINS + view.frame.size.height);
    BOOL reachedDeletedView = FALSE;
    for(UIView *subview in [self.addContentView visibleViews]) {
        if(reachedDeletedView) {
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 subview.frame = CGRectOffset(subview.frame, 0.0f, -(view.frame.size.height + ROW_MARGINS));
                             }
                             completion:^(BOOL finished) {
                                 [self.addContentView reloadData];
                             }
             ];
            delay+=0.03;

        }
        if(subview == view) {
            reachedDeletedView = TRUE;
            [view clearData];
            [view removeFromSuperview];
            self.totalViewHeight -= (ROW_MARGINS + view.frame.size.height);
        }
    }
}

- (void) updateContentView:(ContentView *)view toSize:(CGSize)size {
    BOOL startAnimating = NO;
    NSLog(@"animating to: %f",size.height);
    if(view.frame.size.height != size.height) {
        CGSize oldSize = CGSizeMake(view.frame.size.width, view.frame.size.height);
        NSLog(@"oldSize: %f,%f", oldSize.width, oldSize.height);
        for(UIView* subview in [self.addContentView visibleViews]) {
            NSLog(@"old location: %f,%f", subview.frame.origin.x, subview.frame.origin.y);
            if (startAnimating) {
                [UIView animateWithDuration:0.1
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     subview.frame = CGRectOffset(subview.frame, 0, (size.height - oldSize.height));
                                 }
                                 completion:NULL];
            }
            else if(subview == view) {
                startAnimating = YES;
                [UIView animateWithDuration:0.1
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, size.width, size.height);
                                 }
                                 completion:NULL];
            }

            NSLog(@"new location: %f,%f", subview.frame.origin.x, subview.frame.origin.y);
        }
    }
}


@end
