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

@protocol LeaveGemViewControllerDelegate <NSObject>
- (void) dropGemWithContent:(NSArray *)content;
@end

@interface LeaveGemViewController : UIViewController <ALRadialMenuDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>

- (void)addContentPress:(UIButton *)sender;
- (IBAction)dropGemButtonPress:(id)sender;
- (IBAction)cancelButtonPress:(id)sender;
- (IBAction)tapGestureRecognized:(id)sender;



@property (weak, nonatomic) UIImage *blurImage;
@property (strong, nonatomic) ALRadialMenu *radialMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) id<LeaveGemViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end
