//
//  HireTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HireInfo.h"
#import "MNMRemoteImageView.h"

@interface HireTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet MNMRemoteImageView *ivProfile;
@property(nonatomic, weak) IBOutlet UILabel *lblUsername;
@property(nonatomic, weak) IBOutlet UILabel *lblRole;
@property(nonatomic, weak) IBOutlet UILabel *lblWriteReview;

@property(nonatomic, weak) IBOutlet UILabel *lblPrice;
@property(nonatomic, weak) IBOutlet UILabel *lblDate;

@property(nonatomic, weak) IBOutlet UIView *viewRating;
@property(nonatomic, weak) IBOutlet UIImageView *ivStar1;
@property(nonatomic, weak) IBOutlet UIImageView *ivStar2;
@property(nonatomic, weak) IBOutlet UIImageView *ivStar3;
@property(nonatomic, weak) IBOutlet UIImageView *ivStar4;
@property(nonatomic, weak) IBOutlet UIImageView *ivStar5;

@property(nonatomic, weak) IBOutlet UIView *viewMain;

- (void) setHireInfo:(HireInfo *)hireInfo;


@end
