//
//  Content.m
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "ContentView.h"

@interface ContentView()
//Private property for the relevant content in the contentView
@property (nonatomic, weak) NSObject *content;
//Private property for the relevant button image for the contentView
@property (nonatomic, strong) UIImage * buttonImage;
@end

@implementation ContentView

//These implementations are included mostly to satisfy the compiler..

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