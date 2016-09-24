//
//  MessageTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageInfo.h"

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *ivProfile;

@property(nonatomic, weak) IBOutlet UIView *viewInfo;
@property(nonatomic, weak) IBOutlet UIView *viewMessage;
@property(nonatomic, weak) IBOutlet UILabel *lblMessage;
@property(nonatomic, weak) IBOutlet UILabel *lblTime;

@property(nonatomic, weak) IBOutlet UIView *viewButtons;
@property (nonatomic, weak) IBOutlet UIButton *btnDecline;
@property (nonatomic, weak) IBOutlet UIButton *btnAccept;

@property(nonatomic, weak) IBOutlet UIView *viewMain;

- (void) setMessage:(MessageInfo *)message;
+ (float) getHeight:(MessageInfo *)message width:(float)width;

@end
