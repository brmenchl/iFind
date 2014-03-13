//
//  CreateAccountViewController.h
//  iFind
//
//  Created by Bradley Menchl on 3/11/14.
//  Copyright (c) 2014 FuarkNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateAccountViewController;
@protocol CreateAccountViewControllerDelegate <NSObject, UITextFieldDelegate>
- (void) viewController:(UIViewController *)controller didUserLoginSuccessfully:(BOOL)success;
@end

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *emailFieldAgain;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFieldAgain;
@property (weak, nonatomic) IBOutlet UIButton *createLockerButton;
- (IBAction)tapAwayGesture:(id)sender;

- (IBAction)createLockerPress:(id)sender;
@property (nonatomic, assign) id <CreateAccountViewControllerDelegate> delegate;

@end
