//
//  GGAddContentViewController.h
//  iFind
//
//  Created by Bradley Menchl on 4/4/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAddContentView.h"
#import "ContentView.h"
#import "ALRadialMenu.h"

@interface GGAddContentViewController : UIViewController <ALRadialMenuDelegate, GGAddContentViewDataSource, ContentViewDelegate>
@property (weak, nonatomic) IBOutlet GGAddContentView *addContentView;

- (NSInteger) totalViewHeight;

@property (readonly) NSInteger totalViewHeight;

@end
