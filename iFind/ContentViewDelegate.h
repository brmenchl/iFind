//
//  ContentViewDelegate.h
//  iFind
//
//  Created by Bradley Menchl on 4/9/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ContentView;
 
@protocol ContentViewDelegate <NSObject>

- (void)addAndAnimateForView:(UIView *)view;
- (void) contentViewWillBeDeleted:(ContentView *)view;
- (void) updateContentView:(ContentView *)view toSize:(CGSize)size;
@end
