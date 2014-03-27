//
//  ImageContentView.m
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "ImageContentView.h"

@interface ImageContentView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *buttonImage;
@end

@implementation ImageContentView

- (id) init {
    CGRect main = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:CGRectMake(0,0,main.size.width, main.size.height/2)];
    if(self) {
        self.buttonImage = [UIImage imageNamed:@"orkut.png"];
        self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void) setImage:(UIImage *)image {
    [self.imageView setImage:image];
    [self addSubview:self.imageView];
}

-(id)contentData {
    return self.imageView.image;
}

-(void)clearData {
    self.imageView.image = nil;
}

@end
