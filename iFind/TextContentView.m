//
//  TextContentView.m
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "TextContentView.h"

@interface TextContentView()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImage *buttonImage;
@end
@implementation TextContentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.textView = [[UITextView alloc] initWithFrame:self.frame];
        self.textView.delegate = self;
        [self.textView setShowsVerticalScrollIndicator:NO];
        [self.textView setShowsHorizontalScrollIndicator:NO];
        self.textView.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.4];
        [self addSubview:self.textView];
    }
    return self;
}

-(id) init {
    CGRect main = [UIScreen mainScreen].bounds;
    self = [self initWithFrame:CGRectMake(0,0,main.size.width, 60)];
    if(self) {
        self.buttonImage = [UIImage imageNamed:@"messenger-generic.png"];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 140) ? NO : YES;
}

-(id)contentData {
    return self.textView.text;
}

-(void)clearData {
    self.textView.text = @"";
}

@end
