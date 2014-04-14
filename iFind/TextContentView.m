//
//  TextContentView.m
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "TextContentView.h"

@interface TextContentView()
//The content of the textContentView, a textview for users to write a message in.
@property (nonatomic, strong) UITextView *textView;
//Button image for the textContentView
@property (nonatomic, strong) UIImage *buttonImage;
@end

@implementation TextContentView


//initWithFrame, sets up textView and adds it to the view
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - DELETE_BUTTON_MARGIN, self.frame.size.height)];
        self.textView.delegate = self;
        [self.textView setShowsVerticalScrollIndicator:NO];
        [self.textView setShowsHorizontalScrollIndicator:NO];
        self.textView.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.4];
        [self addSubview:self.textView];
    }
    return self;
}

//Generic init method allowing textcontentview to specify its own dimensions and buttonimage
//This calls initWithFrame.  Only use init method on textcontentview
-(id) init {
    self = [self initWithFrame:[self getDefaultFrame]];
    if(self) {
        self.buttonImage = [UIImage imageNamed:@"messenger-generic.png"];
    }
    return self;
}

- (CGRect) getDefaultFrame {
    CGRect main = [UIScreen mainScreen].bounds;
    return CGRectMake(10, 0, main.size.width - 20, 30);
}

#pragma UITextViewDelegate method
- (void) textViewDidChange:(UITextView *)textView {
    CGRect frame = textView.frame;
    frame.size.height = [textView sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)].height;
    textView.frame = frame;
    [self.delegate updateContentView:self toSize:textView.frame.size];
}


#pragma ContentView methods
//buttonImage doesn't need to be overidden

-(id)contentData {
    return self.textView.text;
}

-(void)clearData {
    self.textView.text = @"";
}

@end
