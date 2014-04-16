//
//  GGAddContentView.m
//  iFind
//
//  Created by Bradley Menchl on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GGAddContentView.h"
#import "RDVKeyboardAvoidingScrollView.h"


@interface GGAddContentView()
@property (readwrite) RDVKeyboardAvoidingScrollView *scrollView;
@property (nonatomic) NSMutableArray *extraViews;
@property (nonatomic) NSMutableSet *reuseSet;
@end

@implementation GGAddContentView {
    Class _subClass;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.extraViews = [[NSMutableArray alloc] init];
        self.scrollView = [[RDVKeyboardAvoidingScrollView alloc] initWithFrame:self.frame];
        [self addSubview:self.scrollView];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.alwaysBounceVertical = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.frame;
    [self refreshView];
}

// based on the current scroll location, recycles off-screen cells and
// creates new ones to fill the empty space.
-(void) refreshView {
    if (CGRectIsNull(self.scrollView.frame)) {
        return;
    }
    // set the scrollview height
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width,[self.dataSource totalViewHeight] + [self.dataSource rowMargins]/2);
    float topEdgeForRow = 0;
    
    if(self.recycleCells) {
        // remove cells that are no longer visible
        for (UIView* cell in [self cellSubviews]) {
            // is the cell off the top of the scrollview?
            if (cell.frame.origin.y + cell.frame.size.height < self.scrollView.contentOffset.y) {
                [self recycleCell:cell];
            }
            // is the cell off the bottom of the scrollview?
            if (cell.frame.origin.y > self.scrollView.contentOffset.y + self.scrollView.frame.size.height) {
                [self recycleCell:cell];
            }
        }
    }
    int firstIndex = self.recycleCells ? MAX(0, floor(self.scrollView.contentOffset.y / [self.dataSource rowHeight])) : 0;
    int lastIndex = self.recycleCells ? MIN([self.dataSource numberOfRows], firstIndex + 1 + ceil(self.scrollView.frame.size.height /[self.dataSource rowHeight])) : (int)[self.dataSource numberOfRows];
//    NSLog(@"first index: %i, last index %i",firstIndex, lastIndex);
    for(int row = firstIndex; row < lastIndex; row++) {
        UIView* cell = [self cellWithTopEdge:topEdgeForRow];
        if (!cell) {
            // create a new cell and add to the scrollview
            cell = [self.dataSource cellForRow:row];
            CGRect frame = cell.frame;
            frame.origin.y = topEdgeForRow;
            cell.frame = frame;
            [self.scrollView insertSubview:cell atIndex:0];
        }
        topEdgeForRow += (cell.frame.size.height + [self.dataSource rowMargins]);
        if(!CGAffineTransformIsIdentity([cell.layer affineTransform])) {
            
            [UIView animateWithDuration:0.4
                                  delay:0.4
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.layer.transform = CATransform3DIdentity;
                             }
                             completion:NULL];
        }
    }
    for(UIView * extraView in self.extraViews) {
        if(extraView.superview != self.scrollView) {
            [self.scrollView insertSubview:extraView atIndex:0];
        }
        extraView.frame = CGRectMake(self.bounds.size.width/2 - 20, (topEdgeForRow), 40, 40);
        topEdgeForRow += (extraView.frame.size.height + [self.dataSource rowMargins]);
    }
}

// recycles a cell by adding it the set of reuse cells and removing it from the view
-(void) recycleCell:(UIView*)cell {
    [self.reuseSet addObject:cell];
    [cell removeFromSuperview];
}

-(UIView*)dequeueReusableCell {
    // first obtain a cell from the reuse pool
    UIView* cell = [self.reuseSet anyObject];
    if (cell) {
        NSLog(@"Returning a cell from the pool");
        [self.reuseSet removeObject:cell];
    }
    // otherwise create a new cell
    if (!cell) {
        NSLog(@"Creating a new cell");
        cell = [[_subClass alloc] init];
    }
    return cell;
}

// returns the cell for the given row, or nil if it doesn't exist
-(UIView*) cellWithTopEdge:(float)edge {
    for (UIView* cell in [self cellSubviews]) {
        if (cell.frame.origin.y == edge) {
            return cell;
        }
    }
    return nil;
}

// the scrollView subviews that are cells
-(NSArray*)cellSubviews {
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    for (UIView* subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:_subClass]) {
            [cells addObject:subView];
        }
    }
    return cells;
}

- (NSArray *)visibleViews {
    NSMutableArray *views = [[self cellSubviews] mutableCopy];
    for (UIView *extraView in self.extraViews) {
        [views addObject:extraView];
    }
    NSArray* sortedViews = [views sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* view1 = (UIView*)obj1;
        UIView* view2 = (UIView*)obj2;
        float result = view2.frame.origin.y - view1.frame.origin.y;
        if (result > 0.0) {
            return NSOrderedAscending;
        } else if (result < 0.0){
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return sortedViews;
}

-(void)registerClassForSubViews:(Class)subClass {
    _subClass = subClass;
}


#pragma mark - UIScrollViewDelegate handlers
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.delegate respondsToSelector:@selector(scrollViewBeginDragging)]) {
        [self.delegate scrollViewBeginDragging];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshView];
}

#pragma mark - property setters
-(void)setDataSource:(id<GGAddContentViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
}

-(void)reloadData {
    // remove all subviews
    [[self cellSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}

- (void) addExtraView:(UIView *)view {
    [self.extraViews addObject:view];
}

@end
