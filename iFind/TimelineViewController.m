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
@property (nonatomic) NSMutableArray *gemMetadataArray; //holds arrays of gemMetadata info  Arrays are grouped by gem.
@property (nonatomic) CGPoint lastScrollLocation;
@end

@implementation TimelineViewController

static CGFloat const ROW_HEIGHT = 40;
static CGFloat const DRAWER_HEIGHT = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.gemMetadataArray) {
        self.gemMetadataArray = [[NSMutableArray alloc] init];
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
        [self.gemMetadataArray removeAllObjects];
        for (PFObject *object in objects) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:object];
            for (PFObject *otherObject in objects) {
                if(![object.objectId isEqualToString: otherObject.objectId] && [object[ParseMetaGemReferenceKey] isEqual: otherObject[ParseMetaGemReferenceKey]]) {
                    [tempArray addObject:object];
                }
            }
            [self.gemMetadataArray addObject:tempArray];
        }
        NSLog(@"array: %@",self.gemMetadataArray);
        [self.timelineTableView reloadData];
    }];
}

- (UIView *) cellForRow:(NSInteger)row {
//    TimelineAccordianView* cell = (TimelineAccordianView *)[self.timelineTableView dequeueReusableCell];
    TimelineAccordianView *cell = [[TimelineAccordianView alloc] init];
    [cell setMetadataArray:self.gemMetadataArray[row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger) numberOfRows {
    return [self.gemMetadataArray count];
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
//    [self.timelineTableView reloadData];
}

- (NSInteger) rowMargins {
    return 0;
}

- (CGFloat) rowHeight {
    return ROW_HEIGHT;
}

- (NSInteger) totalViewHeight {
    return opened ? ([self.gemMetadataArray count] - 1) * ROW_HEIGHT + DRAWER_HEIGHT : [self.gemMetadataArray count] * ROW_HEIGHT;
}

@end
