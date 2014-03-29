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
        self.textView = [[UITextView alloc] initWithFrame:self.frame];
        self.textView.delegate = self;
        [self.textView setShowsVerticalScrollIndicator:YES];
        [self.textView setShowsHorizontalScrollIndicator:NO];
        self.textView.backgroundColor = [UIColor colorWithRed:0.68 green:0.71 blue:0.71 alpha:0.4];
        [self addSubview:self.textView];
    }
    return self;
}

//Generic init method allowing textcontentview to specify its own dimensions and buttonimage
//This calls initWithFrame.  Only use init method on textcontentview
-(id) init {
    CGRect main = [UIScreen mainScreen].bounds;
    self = [self initWithFrame:CGRectMake(0,0,main.size.width, 60)];
    if(self) {
        self.buttonImage = [UIImage imageNamed:@"messenger-generic.png"];
    }
    return self;
}


#pragma UITextViewDelegate method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //Only allowing 140 characters in message (we can change this, this is the twitter amount)
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 140) ? NO : YES;
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
