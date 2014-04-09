//
//  GGAddContentView.h
//  iFind
//
//  Created by Bradley Menchl on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAddContentViewDataSource.h"
#import "GGAddContentViewDelegate.h"

#define ROW_MARGINS 50

@interface GGAddContentView : UIView <UIScrollViewDelegate>

// the object that acts as the data source for this list
@property (nonatomic, assign) id<GGAddContentViewDataSource> dataSource;

//// the object that acts as the delegate for this list
@property (nonatomic, assign) id<GGAddContentViewDelegate> delegate;

// forces the list to dispose of all the cells and re-build the list.
-(void)reloadData;

// the UIScrollView that hosts the list contents
@property (nonatomic, readonly) UIScrollView* scrollView;

@property (nonatomic, readonly) UIButton *addContentButton;

-(NSArray*)cellSubviews;

-(NSArray *)visibleViews;

// registers a class for use as new subviews
-(void)registerClassForSubViews:(Class)subClass;

@end
