//
//  GemContentContainerView.m
//  iFind
//
//  Created by Bradley Menchl on 3/17/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "GemContentContainerView.h"

@interface GemContentContainerView()
@property (strong)NSString * type;

@end

@implementation GemContentContainerView


- (id)initWithChildView:(ContentView *)view frame:(CGRect) frame type:(NSString *)type {
    self = [self initWithFrame:frame];
    if(self) {
        self.type = type;
        CGRect rect = self.bounds;
        rect.origin.x += 55;
        view.frame = rect;
        view.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.5];
        [self addSubview:view];
        self.view = view;
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    return self;
}

- (void) closeButtonPress {
    [[NSNotificationCenter defaultCenter] postNotificationName:GemContentDeletedNotification object:self userInfo:[NSDictionary dictionaryWithObject:self.type forKey:@"Type"]];
    [self removeFromSuperview];
}


@end
