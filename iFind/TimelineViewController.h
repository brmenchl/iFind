//
//  TimelineViewController.h
//  iFind
//
//  Created by Bradley Menchl on 4/9/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAddContentView.h"
#import "TimelineAccordianView.h"

@interface TimelineViewController : UIViewController <GGAddContentViewDataSource, GGAddContentViewDelegate, TimelineAccordianViewDelegate>
@property (strong, nonatomic) IBOutlet GGAddContentView *timelineTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
