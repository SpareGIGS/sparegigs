//
//  MessageTableViewCell.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MessageTableViewCell.h"

#import "DataManager.h"

@implementation MessageTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMessage:(MessageInfo *)message
{
    self.viewMessage.layer.cornerRadius = 5; // this value vary as per your desire
    self.viewMessage.clipsToBounds = YES;
    
    self.viewButtons.layer.cornerRadius = self.viewButtons.frame.size.height / 2; // this value vary as per your desire
    self.viewButtons.clipsToBounds = YES;
    
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
    
    if([message isPenddingOffer]) {
        self.viewButtons.hidden = NO;
        self.viewInfo.frame = CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewMain.frame.size.height - 40);
        
    } else {
        self.viewButtons.hidden = YES;
        self.viewInfo.frame = CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewMain.frame.size.height - 20);
    }
}

+ (float) getHeight:(MessageInfo *)message width:(float)width
{
    float labelWidth = width - 180;
    
    CGSize textViewSize = [message.msgBody sizeWithFont:[UIFont fontWithName:@"Lato" size:14.0f]
                                      constrainedToSize:CGSizeMake(labelWidth, FLT_MAX)
                                          lineBreakMode:UILineBreakModeWordWrap];
    
    float height = textViewSize.height + 34;
    height = MAX(height, 50);
    
    if([message isPenddingOffer]) {
        height += 30;
    }
    
    return height;
}

@end
