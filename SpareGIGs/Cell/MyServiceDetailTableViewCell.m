//
//  MyServiceDetailTableViewCell.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MyServiceDetailTableViewCell.h"

#import "ScheduleTableViewCell.h"

#import "DataManager.h"

@interface MyServiceDetailTableViewCell()
{
    NSArray *_arySchedules;
}

@property(nonatomic, weak) IBOutlet UIView *viewContainer;

@end

@implementation MyServiceDetailTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSchedule:(NSArray *)arySchedules
{
    if(arySchedules == nil) return;
    
    self.viewContainer.layer.borderColor = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f].CGColor;
    self.viewContainer.layer.borderWidth = 1.0f;
    
    _arySchedules = arySchedules;
    
    [self.tvSchedules reloadData];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arySchedules.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_SCHEDULE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UserServiceScheduleInfo *schedule = [_arySchedules objectAtIndex:indexPath.row];
    
    cell.lblRate.text = [NSString stringWithFormat:@"$%d/hr", schedule.user_service_rate];
    cell.lblDates.text = [DataManager getDatesString:schedule.aryDates];
    
    if(schedule.user_service_anytime == 1)
        cell.lblTime.text = @"Any Time";
    else
        cell.lblTime.text = [NSString stringWithFormat:@"%@ to %@", schedule.startTime, schedule.endTime];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
