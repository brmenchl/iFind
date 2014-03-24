//
//  GemContentContainerView.h
//  iFind
//
//  Created by Bradley Menchl on 3/17/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ContentView.h"

@interface GemContentContainerView : UIView
- (id) initWithChildView:(ContentView *)view frame:(CGRect)frame type:(NSString *)type;
- (void) closeButtonPress;

@property (nonatomic, strong) ContentView * view;
@end
