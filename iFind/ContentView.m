//
//  Content.m
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "ContentView.h"

@interface ContentView()
@property (nonatomic, weak) NSObject *content;
@property (nonatomic, strong) UIImage * buttonImage;
@end

@implementation ContentView

- (id) contentData {
    return self.content;
}

- (UIImage *)buttonImage {
    return self.buttonImage;
}

- (void) clearData {
    self.content = nil;
}

@end
