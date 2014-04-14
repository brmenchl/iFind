//
//  TimelineViewController.m
//  iFind
//
//  Created by Bradley Menchl on 4/9/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "TimelineViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface TimelineViewController () {
    BOOL opened;
}
@property (nonatomic) NSMutableArray *timelineArray; //holds arrays of gemMetadata info  Arrays are grouped by gem.
@property (nonatomic) CGPoint lastScrollLocation;
@end

@implementation TimelineViewController

static CGFloat const ROW_HEIGHT = 40;

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.timelineArray) {
        self.timelineArray = [[NSMutableArray alloc] init];
    }
    
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    [self.timelineTableView setRecycleCells:NO];
    [self.timelineTableView registerClassForSubViews:[TimelineAccordianView class]];
    opened = NO;
    self.lastScrollLocation = CGPointZero;
    
    [PFObject fetchAllIfNeededInBackground:[PFUser currentUser][ParseUserTimelineKey] block:^(NSArray *objects, NSError *error) {
        if(error) {
            NSLog(@"%@", [[[error userInfo] objectForKey:@"NSUnderlyingErrorKey"]localizedDescription]);
            return;
        }
        [self.timelineArray removeAllObjects];
        for (PFObject *object in objects) {
            [self.timelineArray addObject:object];
        }
        NSLog(@"array: %@",self.timelineArray);
        [self.timelineTableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIView *) cellForRow:(NSInteger)row {
//    TimelineAccordianView* cell = (TimelineAccordianView *)[self.timelineTableView dequeueReusableCell];
    TimelineAccordianView *cell = [[TimelineAccordianView alloc] init];
    [cell setMetadata:self.timelineArray[row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger) numberOfRows {
    return [self.timelineArray count];
}

- (void) expandView:(TimelineAccordianView *)view {
    [self.timelineTableView.scrollView setContentOffset:(!view.opened ? self.lastScrollLocation : view.frame.origin) animated:YES];
    self.timelineTableView.scrollView.scrollEnabled = !view.opened;
    BOOL startAnimating = NO;
    for (TimelineAccordianView *aView in [self.timelineTableView visibleViews]) {
        if(startAnimating && aView != view) {
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 aView.frame = CGRectOffset(aView.frame, 0, !view.opened ? -(self.timelineTableView.scrollView.frame.size.height - 40) : (self.timelineTableView.scrollView.frame.size.height - 40));
                             }
                             completion:NULL
             ];
        }
        if(aView == view) {
            startAnimating = YES;
        }
    }
}

- (NSInteger) rowMargins {
    return 0;
}

- (CGFloat) rowHeight {
    return ROW_HEIGHT;
}

- (NSInteger) totalViewHeight {
    return opened ? ([self.timelineArray count] - 1) * ROW_HEIGHT + self.timelineTableView.scrollView.frame.size.height : [self.timelineArray count] * ROW_HEIGHT;
}

@end
