//
//  TimelineAccordianView.m
//  iFind
//
//  Created by Bradley Menchl on 4/9/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "TimelineAccordianView.h"
#import "AccordianDrawerView.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface TimelineAccordianView()

@property (nonatomic) UIView *header;
@property (nonatomic) UILabel *headerLabel;
@property (nonatomic) UIView *drawer;
@property (nonatomic) NSDateFormatter *formatter;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIPageControl *pageControl;
@end

@implementation TimelineAccordianView

static CGFloat const HEADER_HEIGHT = 40;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opened = NO;
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateStyle:NSDateFormatterLongStyle];
        UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
        self.drawer = [[UIView alloc] initWithFrame:CGRectNull];
        
        self.drawer.backgroundColor = [UIColor colorWithRed:0.6 green:0.57 blue:0.2 alpha:1];
        self.drawer.hidden = YES;
        [self addSubview:self.drawer];
        
        self.header = [[UIView alloc] initWithFrame:CGRectNull];
        self.header.backgroundColor = [UIColor colorWithRed:0.77 green:0.65 blue:0.32 alpha:1];
        [self.header addGestureRecognizer:recognizer];
        
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        self.headerLabel.textColor = [UIColor colorWithRed:0.61 green:0.2 blue:0.12 alpha:1];
        self.headerLabel.font = [UIFont fontWithName:@"Futura" size:18];
        [self.header addSubview:self.headerLabel];
        
        [self addSubview:self.header];
        
        self.clipsToBounds = YES;
    }

    return self;
}

- (id)init {
    CGRect mainBounds = [UIScreen mainScreen].bounds;
    self = [self initWithFrame:CGRectMake(0,0,mainBounds.size.width, HEADER_HEIGHT)];
    return self;
}

- (void) didMoveToSuperview {
    self.drawer.frame = CGRectMake(0, 40, self.superview.frame.size.width, self.superview.frame.size.height - 40);
    self.drawer.frame = CGRectOffset(self.drawer.frame, 0, -(self.drawer.frame.size.height - HEADER_HEIGHT));
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.drawer.frame.size.width,self.drawer.frame.size.height)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    float pageStart = 0;
    AccordianDrawerView *generalDrawer = [AccordianDrawerView createGeneralInfoDrawer:self.metadata frame:CGRectMake(0, pageStart, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [self.scrollView addSubview:generalDrawer];
    pageStart += self.scrollView.frame.size.width;
    if(self.metadata[ParseMetaTextContentKey]) {
        AccordianDrawerView *drawerContents = [[AccordianDrawerView alloc] initWithFrame:CGRectMake(pageStart, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [drawerContents setContent:self.metadata[ParseMetaTextContentKey]];
        [self.scrollView addSubview:drawerContents];
        pageStart += self.scrollView.frame.size.width;
    }
    if(self.metadata[ParseMetaImageContentKey]) {
        AccordianDrawerView *drawerContents = [[AccordianDrawerView alloc] initWithFrame:CGRectMake(pageStart, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [drawerContents setContent:self.metadata[ParseMetaImageContentKey]];
        [self.scrollView addSubview:drawerContents];
        pageStart += self.scrollView.frame.size.width;
    }
    if(self.metadata[ParseMetaSoundcloudContentKey]) {
        AccordianDrawerView *drawerContents = [[AccordianDrawerView alloc] initWithFrame:CGRectMake(pageStart, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [drawerContents setContent:self.metadata[ParseMetaSoundcloudContentKey]];
        [self.scrollView addSubview:drawerContents];
        pageStart += self.scrollView.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(pageStart, self.scrollView.frame.size.height);
    [self.drawer addSubview:self.scrollView];

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.origin.y + self.scrollView.frame.size.height - 60, self.scrollView.frame.size.width, 50)];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.enabled = YES;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.highlighted = YES;
    self.pageControl.numberOfPages = floor(pageStart/self.scrollView.frame.size.width);
    self.pageControl.currentPage = 0;
    [self.drawer addSubview:self.pageControl];
}

- (void) layoutSubviews {
    self.header.frame = CGRectMake(0, 0, self.frame.size.width, HEADER_HEIGHT);
    self.headerLabel.frame = CGRectMake(10, self.header.frame.origin.y, self.header.frame.size.width - 50, self.header.frame.size.height);
}

- (void) handleTap:(id)sender {
    NSLog(@"didtap");
    self.opened = !self.opened;
    self.scrollView.contentOffset = CGPointZero;
    if(self.opened) self.drawer.hidden = NO;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect vFrame = self.frame;
                         vFrame.size.height = !self.opened ? HEADER_HEIGHT : self.superview.frame.size.height;
                         self.frame = vFrame;
                         
                         self.drawer.frame = CGRectOffset(self.drawer.frame, 0, !self.opened ? -(self.drawer.frame.size.height - 40) : self.drawer.frame.size.height - 40);
                     }
                     completion:^(BOOL finished) {
                         if(!self.opened) self.drawer.hidden = YES;
                     }];
    [self.delegate expandView:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    NSLog(@" page is now %i",page);
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
}

- (void) setMetadata:(PFObject *)metadata {
    _metadata = metadata;
    NSDate *pickUpDate = metadata[ParseMetaPickUpDateKey];
    NSString *pickUpDateString = [self.formatter stringFromDate: pickUpDate];
    [self.headerLabel setText: pickUpDateString];
}

@end
