//
//  BaseViewController.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) int reqType;


- (void) showAlert:(nullable NSString *) title withMsg:(nullable NSString *)msg;

- (void) startActivityAnimation;
- (void) stopActivityAnimation;

- (void) loginToFacebook;
- (void) loginToTwitter;
- (void) loginToGoogle;

- (void) runUIProcess:(nullable SEL) act;

- (void) sendEmailWith:(nullable NSString *)email subject:(nullable NSString *)subject body:(nullable NSString *)message;
- (void) sendSMS:(nullable NSString *) phoneNumber message:(nullable NSString *)message;
- (void) callPhoneNumber:(nullable NSString *) phoneNumber;

@end

