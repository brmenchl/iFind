//
//  LeaveGemViewController.m
//  iFind
//
//  Created by Bradley Menchl on 3/16/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "LeaveGemViewController.h"
#import "UIImage+ImageEffects.h"
#import "ContentView.h"
#import "TextContentView.h"
#import "ImageContentView.h"
#import "AppDelegate.h"

@interface LeaveGemViewController ()
@property (nonatomic, strong) NSMutableArray *unusedContentViews;
@property (nonatomic, strong) NSMutableArray *currentContentViews;
@property (nonatomic, strong) UIButton *addContentButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) ImageContentView *theImageContentView;
@end

@implementation LeaveGemViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.radialMenu = [[ALRadialMenu alloc] init];
	self.radialMenu.delegate = self;
    self.currentContentViews = [[NSMutableArray alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.addContentButton = [[UIButton alloc] init];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.showsCameraControls = YES;
    [self.addContentButton setImage:[UIImage imageNamed:@"plusButton.png"] forState:UIControlStateNormal];
    [self.addContentButton addTarget:self action:@selector(addContentPress:) forControlEvents:UIControlEventTouchUpInside];
    self.addContentButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-15, 0, 30, 30);
    
    //I PUT THIS DUMMY ELEMENT HERE BECAUSE THE IDIOT WHO MADE THE RADIAL MENU DOES 1-BASED COUNTING
    self.unusedContentViews = [[NSMutableArray alloc] initWithObjects:@"dummy", [[TextContentView alloc] init], [[ImageContentView alloc] init], nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.backgroundImageView setImage:self.blurImage];
    [self setBackgroundImageView:self.backgroundImageView];
    [self.tableView reloadData];
}


-(void) clearAllData {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    [self.unusedContentViews addObjectsFromArray:self.currentContentViews];
    [self.currentContentViews removeAllObjects];
    for(int i = 1; i < [self.unusedContentViews count]; i++) {
        [self.unusedContentViews[i] clearData];
        [self.unusedContentViews[i] removeFromSuperview];
    }
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == [self.currentContentViews count] || self.currentContentViews == nil) {
        return 40;
    }
    return ((ContentView *)[self.currentContentViews objectAtIndex:indexPath.section]).frame.size.height;
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] < [self.currentContentViews count]) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] < [self.currentContentViews count]) {
        ContentView *object = [self.currentContentViews objectAtIndex:indexPath.section];
        [object clearData];
        [object removeFromSuperview];
        [self.unusedContentViews addObject:object];
        [self.currentContentViews removeObject:object];
        [self.tableView reloadData];
    }
}

- (void)addContentPress:(UIButton *)sender {
    [self.radialMenu buttonsWillAnimateFromButton:sender withFrame:[sender convertRect:sender.bounds toView:self.view] inView:self.view];
}

- (IBAction)dropGemButtonPress:(id)sender {
    NSMutableArray *dataForGem = [[NSMutableArray alloc] init];
    for(ContentView *content in self.currentContentViews) {
        [dataForGem addObject:[content contentData]];
    }
    [self.delegate dropGemWithContent:dataForGem];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self clearAllData];
}

- (IBAction)cancelButtonPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self clearAllData];
}

- (IBAction)tapGestureRecognized:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
	return [self.unusedContentViews count] - 1;
}


- (NSInteger) arcSizePerButton:(ALRadialMenu *)radialMenu {
	return 45;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
	return 70;
}


- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
    if([self.unusedContentViews count] == 0) {
        return nil;
    }
    return [[self.unusedContentViews objectAtIndex:index] buttonImage];
}


- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
    [self.radialMenu itemsWillDisapearIntoButton:self.addContentButton];
    if([[self.unusedContentViews objectAtIndex:index] isKindOfClass:[ImageContentView class]]) {
        self.theImageContentView = [self.unusedContentViews objectAtIndex:index];
        [self presentImagePicker];
    }
    else if([[self.unusedContentViews objectAtIndex:index] isKindOfClass:[TextContentView class]]) {
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
        [self presentViewController:self.imagePickerController animated:YES completion:NULL];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //This checks to see if the image was edited
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [photo drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.theImageContentView setImage:smallImage];
    [self.currentContentViews addObject:self.theImageContentView];
    [self.unusedContentViews removeObject:self.theImageContentView];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger) arcStartForRadialMenu:(ALRadialMenu *)radialMenu {
    return 45;
}

- (float) buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu {
    return 30;
}

@end
