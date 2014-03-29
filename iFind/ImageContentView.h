//
//  ImageContentView.h
//  iFind
//
//  Created by Bradley Menchl on 3/24/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import "ContentView.h"

@interface ImageContentView : ContentView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//Extra method delayed add an image to an imagecontentview
- (void) setImage:(UIImage *)image;
@end
