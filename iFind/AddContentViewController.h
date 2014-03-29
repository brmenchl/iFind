//
//  LeaveGemViewController.h
//  iFind
//
//  Created by Bradley Menchl on 3/16/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRadialMenu.h"
#import "AppDelegate.h"

@protocol AddContentViewControllerDelegate <NSObject>
- (void) dropGemWithContent:(NSArray *)content;
@end

@interface AddContentViewController : UIViewController <ALRadialMenuDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>


// Handles pressing the drop gem button
- (IBAction)dropGemButtonPress:(id)sender;

// Handles pressing the cancel button
- (IBAction)cancelButtonPress:(id)sender;

// Handles tap gesture to close keyboard
- (IBAction)tapGestureRecognized:(id)sender;

//Outlet for uitableview
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Outlet for background UIImageView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

//Reference to AddContentViewControllerDelegate
@property (nonatomic, retain) id<AddContentViewControllerDelegate> delegate;

@end
