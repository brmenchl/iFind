//
//  GGAddContentViewController.h
//  iFind
//
//  Created by Bradley Menchl on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAddContentView.h"
#import "ContentView.h"
#import "ALRadialMenu.h"

@protocol GGAddContentViewControllerDelegate <NSObject>
- (void) dropGemWithContent:(NSArray *)content;
@end


@interface GGAddContentViewController : UIViewController <ALRadialMenuDelegate, GGAddContentViewDataSource, GGAddContentViewDelegate, ContentViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet GGAddContentView *addContentView;

- (NSInteger) totalViewHeight;

@property (nonatomic) NSInteger totalViewHeight;

- (IBAction)dropGemPress:(id)sender;
- (IBAction)cancelPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong,nonatomic) UIImage *blurImage;

//Reference to AddContentViewControllerDelegate
@property (nonatomic, retain) id<GGAddContentViewControllerDelegate> delegate;
@end
