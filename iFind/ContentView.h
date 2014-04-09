//
//  ContentView.h
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentView;

@protocol ContentViewDelegate <NSObject>
- (void)addAndAnimateForView:(UIView *)view;
- (void) contentViewDeleted:(ContentView *)view;
- (void) updateContentView:(ContentView *)view toSize:(CGSize)size;
@end


@interface ContentView : UIView <UIGestureRecognizerDelegate>

/*
 *  returns the relevant data from the contentView (UIImage, nsstring,...)
 */
-(id)contentData;

/*
 *  returns the image to go on the ALRadial button menu
 */
-(UIImage *)buttonImage;

/*
 *  removes all data from the contentView to refresh view
 */
-(void)clearData;

@property (nonatomic, assign) id <ContentViewDelegate> delegate;

@end
