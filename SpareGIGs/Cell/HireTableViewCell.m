//
//  HireTableViewCell.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "HireTableViewCell.h"

#import "DataManager.h"

@implementation HireTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setHireInfo:(HireInfo *)hireInfo
{
    UserInfo *opp = [hireInfo getOpportunity];
    
    [self.ivProfile displayImageFromURL:opp.profile completionHandler:nil];
    self.lblUsername.text = opp.username;
    
    if([hireInfo isClient]) {
        self.lblRole.text = @"Service Provided:";
    } else {
        self.lblRole.text = @"Service Offered:";
    }
    
    if(hireInfo.rating > 0) {
        self.lblWriteReview.hidden = YES;
        //self.viewMain.frame = CGRectMake(self.viewMain.frame.origin.x, self.viewMain.frame.origin.y, self.viewMain.frame.size.width, 120);
        
        [self updateStars:hireInfo.rating];
        
    } else {
        self.lblWriteReview.hidden = NO;
        //self.viewMain.frame = CGRectMake(self.viewMain.frame.origin.x, self.viewMain.frame.origin.y, self.viewMain.frame.size.width, 90);
    }
    
    self.lblPrice.text = [NSString stringWithFormat:@"Rate: $%d/hr", (int)hireInfo.price];
    self.lblDate.text = [NSString stringWithFormat:@"Date Hired: %@", hireInfo.hiredDate];
}

- (void) updateStars:(NSInteger)rating
{
    self.ivStar5.hidden = !(rating > 4);
    self.ivStar4.hidden = !(rating > 3);
    self.ivStar3.hidden = !(rating > 2);
    self.ivStar2.hidden = !(rating > 1);
    self.ivStar1.hidden = !(rating > 0);
}

@end
