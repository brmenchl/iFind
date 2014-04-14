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
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation ContentView

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30,0,30,30)];
        [self.deleteButton setTitle:@"\u2327" forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteContentView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
}

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

- (void)deleteContentView:(id)sender {
    [self clearData];
    [self.delegate contentViewWillBeDeleted:self];
}

@end
