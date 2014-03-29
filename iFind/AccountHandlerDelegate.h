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

/*
 *  Creates some amount of gems and stores them in the curret user's inventory.
 *  @param count the number of gems to create.
 */
- (void) createGem:(NSUInteger)count;

/*
 *  Handles user login.  If login is successful, the app will switch to the main bouncemenu views.
 *  @param controller Controller sending the message to delegate
 *  @param success Boolean specifying whether login was a success.
 */
- (void) viewController:(UIViewController *)controller didUserLoginSuccessfully:(BOOL)success;

/*
 *  Handles user logout.  If login is successful, the app will switch to the welcome views.
 *  @param controller Controller sending the message to delegate
 *  @param success Boolean specifying whether logout was a success.
 */
- (void) viewController:(UIViewController *)controller didUserLogoutSuccessfully:(BOOL)success;
@end
