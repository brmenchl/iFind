//
//  GGAddContentViewController.m
//  iFind
//
//  Created by Bradley Menchl on 4/4/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GGAddContentViewController.h"
#import "TextContentView.h"
#import "ImageContentView.h"

@interface GGAddContentViewController ()
@property NSMutableArray *currentContentViews;
@property (readwrite) NSInteger totalViewHeight;
//Private property for the animated button menu, centered on the addcontentbutton
@property (nonatomic) ALRadialMenu *radialMenu;
@property (nonatomic) NSMutableArray *unusedContentViews;
//UIImagePickerController to allow camera photo selection
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (assign, nonatomic) CATransform3D initialTransform;
@end

@implementation GGAddContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize radialMenu
    self.radialMenu = [[ALRadialMenu alloc] init];
	self.radialMenu.delegate = self;
    self.addContentView.dataSource = self;
    //Initialize the unused and current content view arrays
    //I PUT THIS DUMMY ELEMENT HERE BECAUSE THE GUY WHO MADE THE RADIAL MENU DOES 1-BASED COUNTING
    self.unusedContentViews = [[NSMutableArray alloc] initWithObjects:@"dummy", [[TextContentView alloc] init], [[ImageContentView alloc] init], nil];
    self.currentContentViews = [[NSMutableArray alloc] init];
    //Initialize imagePicker
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.totalViewHeight = 0;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, -[UIScreen mainScreen].bounds.size.width, 0, 0.0);
    self.initialTransform = transform;
    NSLog(@"VDL");
}

- (NSInteger) numberOfRows {
    return [self.currentContentViews count];
}

- (ContentView *) cellForRow:(NSInteger) row {
    ContentView* cell = [self.currentContentViews objectAtIndex:row];
    [self.addContentView registerCellClass:[cell class]];
    cell.delegate = self;
    return cell;
}


//Handles pressing the add content button
- (void)addContentPress:(UIButton *)sender {
    [self.radialMenu buttonsWillAnimateFromButton:sender withFrame:[sender convertRect:sender.bounds toView:self.view] inView:self.view];
}



#pragma mark - content view delegate methods

- (void) removeContentView:(ContentView *)contentView {
    [self.unusedContentViews addObject:contentView];
    [self.unusedContentViews removeObject:contentView];
    [contentView clearData];
    self.totalViewHeight -= (ROW_MARGINS + contentView.frame.size.height);
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
    [self.radialMenu itemsWillDisapearIntoButton:[self.addContentView addContentButton]];
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
    [self.currentContentViews addObject:self.unusedContentViews[index]];
    [self.unusedContentViews[index] layer].transform = self.initialTransform;
    self.totalViewHeight += (ROW_MARGINS + [self.unusedContentViews[index] frame].size.height);
    [UIView animateWithDuration:0.4
                          delay:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.addContentView reloadData];
                         self.addContentView.addContentButton.frame = CGRectOffset(self.addContentView.addContentButton.frame, 0, ROW_MARGINS + [self.unusedContentViews[index] frame].size.height);
                     }
                     completion:NULL
     ];
    [self.unusedContentViews removeObjectAtIndex:index];

}

@end
