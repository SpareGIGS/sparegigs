//
//  MyMessageTableViewCell.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MyMessageTableViewCell.h"

#import "DataManager.h"

@implementation MyMessageTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMessage:(MessageInfo *)message
{
    self.viewMessage.layer.cornerRadius = 5; // this value vary as per your desire
    self.viewMessage.clipsToBounds = YES;
    
    self.lblMessage.text = message.msgBody;
    
    NSString *msgTimeString = [DataManager getLocalTimeWithServer:message.msgTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TIME_FORMAT_SERVER];
    
    NSString *nowTimeString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *msgTime = [dateFormatter dateFromString:msgTimeString];
    NSDate *nowTime = [dateFormatter dateFromString:nowTimeString];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *sNow = [dateFormatter stringFromDate:nowTime];
    NSString *sMsgTime = [dateFormatter stringFromDate:msgTime];
    
    NSString *showDate = @"";
    if([sNow isEqualToString:sMsgTime]) {
        [dateFormatter setDateFormat:@"hh:mm"];
        showDate = [dateFormatter stringFromDate:msgTime];
    } else {
        [dateFormatter setDateFormat:@"MM/dd"];
        showDate = [dateFormatter stringFromDate:msgTime];
    }
    
    self.lblTime.text = showDate;
}

+ (float) getHeight:(MessageInfo *)message width:(float)width
{
    float labelWidth = width - 180;
    
    CGSize textViewSize = [message.msgBody sizeWithFont:[UIFont fontWithName:@"Lato" size:14.0f]
                                           constrainedToSize:CGSizeMake(labelWidth, FLT_MAX)
                                               lineBreakMode:UILineBreakModeWordWrap];
    
    float height = textViewSize.height + 34;
    height = MAX(height, 50);
    
    return height;
}

@end
