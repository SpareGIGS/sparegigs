//
//  ScheduleTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_SCHEDULE_HEIGHT 80

@interface ScheduleTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblRate;
@property(nonatomic, weak) IBOutlet UILabel *lblDates;
@property(nonatomic, weak) IBOutlet UILabel *lblTime;

@property(nonatomic, weak) IBOutlet UIView *viewMain;

@end
