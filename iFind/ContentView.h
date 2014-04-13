//
//  ContentView.h
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewDelegate.h"

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
