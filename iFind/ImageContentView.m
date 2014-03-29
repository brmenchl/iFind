//
//  ImageContentView.m
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "ImageContentView.h"

@interface ImageContentView()
//Relevant content of imagecontentview, UIImageView holding taken picture
@property (nonatomic, strong) UIImageView *imageView;
//Relevant buttonimage
@property (nonatomic, strong) UIImage *buttonImage;
@end

@implementation ImageContentView


//Generic init method to allow imagecontentview to specify it's own dimensions and button image
//imageview is created here.
- (id) init {
    CGRect main = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:CGRectMake(0,0,main.size.width, main.size.height/2)];
    if(self) {
        //we need to change this image
        self.buttonImage = [UIImage imageNamed:@"orkut.png"];
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

//Delayed sets the image of the imageview and adds it to the overall imagecontentview
- (void) setImage:(UIImage *)image {
    [self.imageView setImage:image];
    [self addSubview:self.imageView];
}

#pragma ContentView methods
//buttonImage doesn't need to be overridden

-(id)contentData {
    return self.imageView.image;
}

-(void)clearData {
    self.imageView.image = nil;
}

@end
