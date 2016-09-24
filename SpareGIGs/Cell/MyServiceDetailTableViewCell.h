//
//  MyServiceDetailTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_MY_SERVICE_DETAIL_HEIGHT 

@interface MyServiceDetailTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblDesc;
@property(nonatomic, weak) IBOutlet UITableView *tvSchedules;

- (void) setSchedule:(NSArray *)arySchedules;

@end
