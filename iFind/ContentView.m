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
@property CGPoint originalCenter;
@property BOOL deleteOnRelease;
@property UILabel *deleteLabel;
@end

@implementation ContentView

// utility method for creating the contextual cues
-(UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0];;
    label.alpha = 0;
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:0];
    return label;
}

-(void) resetDeleteLabel {
    self.deleteLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0];;
    self.deleteLabel.alpha = 0;
    self.deleteLabel.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:0];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    self.deleteLabel.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
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
    [self removeFromSuperview];
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // add delete label
        self.deleteLabel = [self createCueLabel];
        self.deleteLabel.text = @"\t\u2297";
        self.deleteLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.deleteLabel];
        // add a pan recognizer
    }
    return self;
}

@end
