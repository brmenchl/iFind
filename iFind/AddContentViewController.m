//
//  LeaveGemViewController.m
//  iFind
//
//  Created by Bradley Menchl on 3/16/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "AddContentViewController.h"
#import "UIImage+ImageEffects.h"
#import "ContentView.h"
#import "TextContentView.h"
#import "ImageContentView.h"
#import "SoundcloudContentView.h"
#import "AppDelegate.h"

@interface AddContentViewController ()
//Private property for the animated button menu, centered on the addcontentbutton
@property (strong, nonatomic) ALRadialMenu *radialMenu;

//FOR BOTH OF THESE ARRAYS, WE MIGHT WANT TO USE DICTIONARIES, THE CODE GETS WONKY DOWN THERE
//Array of contentviews that have not been added to the gem
@property (nonatomic, strong) NSMutableArray *unusedContentViews;

//Array of contentviews that have been added to the gem already
@property (nonatomic, strong) NSMutableArray *currentContentViews;

//Add content button, on which the radialMenu is placed
@property (nonatomic, strong) UIButton *addContentButton;

//UIImagePickerController to allow camera photo selection
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

//Reference to the imageContentView to allow the view to be created before the imagepicker selects a picture
//There is probably a better way to do this
@property (nonatomic, weak) ImageContentView *theImageContentView;
@end

@implementation AddContentViewController

#pragma ViewController lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    //Initialize radialMenu
    self.radialMenu = [[ALRadialMenu alloc] init];
	self.radialMenu.delegate = self;
    
    //Initialize addContentButton
    self.addContentButton = [[UIButton alloc] init];
    [self.addContentButton setImage:[UIImage imageNamed:@"plusButton.png"] forState:UIControlStateNormal];
    [self.addContentButton addTarget:self action:@selector(addContentPress:) forControlEvents:UIControlEventTouchUpInside];
    self.addContentButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-15, 0, 30, 30);
    
    //Initialize the unused and current content view arrays
    //I PUT THIS DUMMY ELEMENT HERE BECAUSE THE GUY WHO MADE THE RADIAL MENU DOES 1-BASED COUNTING
    self.unusedContentViews = [[NSMutableArray alloc] initWithObjects:@"dummy", [[TextContentView alloc] init], [[ImageContentView alloc] init], [[SoundcloudContentView alloc] init], nil];
    self.currentContentViews = [[NSMutableArray alloc] init];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //Initialize imagePicger
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Reset blurred background
    [self.backgroundImageView setImage:self.blurImage];
    [self.tableView reloadData];
}


//This method runs through all subviews and resets their data to allow for a new gem to be dropped
-(void) clearAllData {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    
    //Replace all contentViews in unusedContentViews
    [self.unusedContentViews addObjectsFromArray:self.currentContentViews];
    [self.currentContentViews removeAllObjects];
    
    //Clear data from every contentView
    for(int i = 1; i < [self.unusedContentViews count]; i++) {
        [self.unusedContentViews[i] clearData];
        [self.unusedContentViews[i] removeFromSuperview];
    }
}

#pragma UITableViewDataSource methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.currentContentViews count] > 0) {
        return [self.currentContentViews count] + 1;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.currentContentViews == nil || [self.currentContentViews count] == 0 || indexPath.section == [self.currentContentViews count]){
        //Adding the add content button in the last section
        [cell addSubview:self.addContentButton];
    }
    else {
        [cell.contentView addSubview:[self.currentContentViews objectAtIndex:indexPath.section]];
    }
    return cell;
}

#pragma UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == [self.currentContentViews count] || self.currentContentViews == nil) {
        return 40;
    }
    return ((ContentView *)[self.currentContentViews objectAtIndex:indexPath.section]).frame.size.height;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] < [self.currentContentViews count]) {
        //Allow deletion on every cell but the add content cell
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] < [self.currentContentViews count]) {
        //Remove deleted item from the view and reset it's content
        ContentView *object = [self.currentContentViews objectAtIndex:indexPath.section];
        [object clearData];
        [object removeFromSuperview];
        [self.unusedContentViews addObject:object];
        [self.currentContentViews removeObject:object];
        [self.tableView reloadData];
    }
}

//Handles pressing the add content button
- (void)addContentPress:(UIButton *)sender {
    [self.radialMenu buttonsWillAnimateFromButton:sender withFrame:[sender convertRect:sender.bounds toView:self.view] inView:self.view];
}

- (IBAction)dropGemButtonPress:(id)sender {
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

- (IBAction)cancelButtonPress:(id)sender {
    //Dismiss the view and clear all data in the view
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self clearAllData];
}

- (IBAction)tapGestureRecognized:(id)sender {
    //Hacky way to make keyboard go away when tapping the screen
    [self.view endEditing:YES];
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
    if([self.unusedContentViews count] == 0) {
        return nil;
    }
    
    //Get button image from each unused content view
    return [[self.unusedContentViews objectAtIndex:index] buttonImage];
}

//Handles user pushing any content button
//Gets relevant contentView from the unusedContentViews array and adds it to the table view
- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    if([[self.unusedContentViews objectAtIndex:index] isKindOfClass:[ImageContentView class]]) {
        
        //Setting temporary imageContentView reference and presenting the imagePicker
        self.theImageContentView = [self.unusedContentViews objectAtIndex:index];
        [self presentImagePicker];
    }
    else if([[self.unusedContentViews objectAtIndex:index] isKindOfClass:[TextContentView class]]) {
        //Add textContentView and reload the table
        [self.currentContentViews addObject:[self.unusedContentViews objectAtIndex:index]];
        [self.unusedContentViews removeObjectAtIndex:index];
        [self.tableView reloadData];
    }
    else if ([[self.unusedContentViews objectAtIndex:index] isKindOfClass:[SoundcloudContentView class]]){
    
        //Add textContentView and reload the table
        [self.currentContentViews addObject:[self.unusedContentViews objectAtIndex:index]];
        [self.unusedContentViews removeObjectAtIndex:index];
        [self.tableView reloadData];
    
    }
}

-(void)presentImagePicker {
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
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:NULL];
    }
}

#pragma UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //Shrink image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [photo drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Set imageContentView content, add it, and reload the table
    [self.theImageContentView setImage:smallImage];
    [self.currentContentViews addObject:self.theImageContentView];
    [self.unusedContentViews removeObject:self.theImageContentView];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
