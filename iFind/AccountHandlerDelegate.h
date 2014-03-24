//
//  AccountHandlerDelegate.h
//  iFind
//
//  Created by Bradley Menchl on 3/23/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccountHandlerDelegate <NSObject>
@required
- (void) createGem:(NSUInteger)count;
- (void) viewController:(UIViewController *)controller didUserLoginSuccessfully:(BOOL)success;
- (void) viewController:(UIViewController *)controller didUserLogoutSuccessfully:(BOOL)success;
@end
