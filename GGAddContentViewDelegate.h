//
//  GGAddContentViewDelegate.h
//  iFind
//
//  Created by Bradley Menchl on 4/7/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ContentView;
@protocol GGAddContentViewDelegate <NSObject>

- (void) addContentPress:(UIButton*)sender;

- (void) scrollViewBeginDragging;

@end
