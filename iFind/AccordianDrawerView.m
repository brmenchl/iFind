//
//  AccordianDrawerView.m
//  iFind
//
//  Created by Bradley Menchl on 4/10/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "AccordianDrawerView.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AccordianDrawerView()
@property (nonatomic) UIScrollView *scrollView;
@end

@implementation AccordianDrawerView


- (void) setContents:(PFObject *)contents {
    _contents = contents;
    float contentSize = 0;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    if(self.contents[ParseMetaTextContentKey]) {
        UILabel *textContent = [[UILabel alloc] init];
        textContent.text = self.contents[ParseMetaTextContentKey];
        textContent.frame = CGRectMake(10, 10, self.scrollView.frame.size.width, 100);
        [self.scrollView addSubview:textContent];
        contentSize += textContent.frame.size.height;
    }
    if(self.contents[ParseMetaImageContentKey]) {
        PFImageView *imageContent = [[PFImageView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, self.frame.size.height)];
        imageContent.file = self.contents[ParseMetaImageContentKey];
        [imageContent loadInBackground];
        imageContent.center = CGPointMake(self.superview.center.x, 100);
        [self.scrollView addSubview:imageContent];
        contentSize += imageContent.frame.size.height;
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, contentSize);
    NSLog(@"Contentsize %f",self.scrollView.contentSize.height);
    [self addSubview:self.scrollView];
}

@end
