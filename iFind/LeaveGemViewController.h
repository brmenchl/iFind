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

@interface LeaveGemViewController : UIViewController <ALRadialMenuDelegate>

- (IBAction)addContentPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addContentButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) UIImage *blurImage;
@property (strong, nonatomic) ALRadialMenu *radialMenu;
- (IBAction)tapGestureRecognizer:(id)sender;
- (IBAction)dropGemButtonPress:(id)sender;

@property (nonatomic, retain) id<LeaveGemViewControllerDelegate> delegate;
@end
