//
//  GGAddContentView.m
//  iFind
//
//  Created by Bradley Menchl on 4/4/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GGAddContentView.h"
#define BUTTON_SIZE 30
@interface GGAddContentView()
@property (readwrite) UIScrollView *scrollView;
@property (nonatomic) UIButton *addContentButton;
@property Class class;
@end

@implementation GGAddContentView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        [self addSubview:self.scrollView];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor]; //TODO
        self.scrollView.delegate = self;
    }
    return self;
}

-(void)layoutSubviews {
    self.scrollView.frame = self.frame;
    [self refreshView];
}

-(void)registerCellClass:(Class)aClass {
    self.class = aClass;
}

// based on the current scroll location, recycles off-screen cells and
// creates new ones to fill the empty space.
-(void) refreshView {
    if (CGRectIsNull(self.scrollView.frame)) {
        return;
    }
    // set the scrollview height
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width,[self.dataSource totalViewHeight] + [self addContentButtonSpace]);
    float topEdgeForRow = 0;
    for(int row = 0; row < [self.dataSource numberOfRows]; row++) {
        UIView* cell = [self cellWithTopEdge:topEdgeForRow];
        if (!cell) {
            // create a new cell and add to the scrollview
            cell = [self.dataSource cellForRow:row];
            CGRect frame = cell.frame;
            frame.origin.y = topEdgeForRow;
            cell.frame = frame;
            if(!CGAffineTransformIsIdentity([cell.layer affineTransform])) {
                [self.scrollView insertSubview:cell atIndex:0];
                [UIView animateWithDuration:0.4
                                      delay:0.4
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     cell.layer.transform = CATransform3DIdentity;
                                 }
                                 completion:NULL];
            }
            }
        topEdgeForRow += (cell.frame.size.height + ROW_MARGINS);
    }
    if(!self.addContentButton) {
        NSLog(@"making button");
        self.addContentButton = [[UIButton alloc] init];
        [self.addContentButton setImage:[UIImage imageNamed:@"plusButton.png"] forState:UIControlStateNormal];
        [self.addContentButton addTarget:self.delegate action:@selector(addContentPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView insertSubview:self.addContentButton atIndex:0];
        self.addContentButton.frame = CGRectMake(self.bounds.size.width/2 - 20, (topEdgeForRow), 40, 40);
    }
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
        if ([subView isKindOfClass:self.class]) {
            [cells addObject:subView];
        }
    }
    return cells;
}


#pragma mark - UIScrollViewDelegate handlers
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

- (NSInteger) addContentButtonSpace {
    return BUTTON_SIZE + ROW_MARGINS;
}
@end
