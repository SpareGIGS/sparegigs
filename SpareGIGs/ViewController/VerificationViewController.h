//
//  VerificationViewController.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "UserInfo.h"

@protocol VerificationDelegate <NSObject>

@optional

- (void)verified:(UserInfo *)user;

@end

@interface VerificationViewController : BaseViewController

@property (nonatomic, assign) id<VerificationDelegate> delegate;
@property (nonatomic, strong) NSString *email;


@end

