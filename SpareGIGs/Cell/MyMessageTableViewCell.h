//
//  MyMessageTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageInfo.h"

@interface MyMessageTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIView *viewMessage;
@property(nonatomic, weak) IBOutlet UILabel *lblMessage;
@property(nonatomic, weak) IBOutlet UILabel *lblTime;

@property(nonatomic, weak) IBOutlet UIView *viewMain;

- (void) setMessage:(MessageInfo *)message;
+ (float) getHeight:(MessageInfo *)message width:(float)width;

@end
