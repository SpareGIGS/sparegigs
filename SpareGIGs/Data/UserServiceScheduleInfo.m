//
//  UserServiceScheduleInfo.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "UserServiceScheduleInfo.h"

#import "Constants.h"

#import "DataManager.h"

@implementation UserServiceScheduleInfo

- (id) init
{
	if ( (self = [super init]) )
	{
        [self _init];
	}
	
	return self;
}

- (void) _init
{
    self.user_service_schedule_id = @"";
    self.user_service_id = @"";
    
    self.user_service_rate = 20;
    
    self.user_service_anytime = 1;
    
    self.startTime = @"8:00 AM";
    self.endTime = @"6:00 PM";
    
    self.aryDates = [[NSMutableArray alloc] init];
}

- (UserServiceScheduleInfo *) clone
{
    UserServiceScheduleInfo *cloned = [[UserServiceScheduleInfo alloc] init];
    
    cloned.user_service_schedule_id = self.user_service_schedule_id;
    cloned.user_service_id = self.user_service_id;
    
    cloned.user_service_rate = self.user_service_rate;
    
    cloned.user_service_anytime = self.user_service_anytime;
    
    cloned.startTime = self.startTime;
    cloned.endTime = self.endTime;
    
    cloned.aryDates = [[NSMutableArray alloc] init];
    for (int index = 0 ; index < self.aryDates.count ; index ++) {
        NSString *dates = [self.aryDates objectAtIndex:index];
        [cloned.aryDates addObject:dates];
    }
    
    return cloned;
}

- (void) copyWithData:(UserServiceScheduleInfo *)schedule
{
    self.user_service_schedule_id = schedule.user_service_schedule_id;
    self.user_service_id = schedule.user_service_id;
    
    self.user_service_rate = schedule.user_service_rate;
    
    self.user_service_anytime = schedule.user_service_anytime;
    
    self.startTime = schedule.startTime;
    self.endTime = schedule.endTime;
    
    [self.aryDates removeAllObjects];
    for (int index = 0 ; index < schedule.aryDates.count ; index ++) {
        NSString *dates = [schedule.aryDates objectAtIndex:index];
        [self.aryDates addObject:dates];
    }
}

- (NSMutableDictionary *) getDictionaryData
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:self.user_service_schedule_id forKey:@"_id"];
    [data setObject:[NSNumber numberWithInt:self.user_service_rate] forKey:@"price"];
    [data setObject:[NSNumber numberWithInt:self.user_service_anytime] forKey:@"any_time"];
    [data setObject:self.startTime forKey:@"start_time"];
    [data setObject:self.endTime forKey:@"end_time"];
    
    NSString *dates = @"";
    for (int index = 0 ; index < self.aryDates.count ; index ++) {
        NSString *date = [self.aryDates objectAtIndex:index];
        if(dates.length == 0) {
            dates = date;
        } else {
            dates = [NSString stringWithFormat:@"%@,%@", dates, date];
        }
    }
    
    [data setObject:dates forKey:@"days"];
    
    return data;
}

- (void) setDataWithDictionary:(NSDictionary *)dictionary
{
    self.user_service_schedule_id = [dictionary objectForKey:@"_id"];
    self.user_service_id = [dictionary objectForKey:@"user_service_id"];
    
    self.user_service_rate = [[dictionary objectForKey:@"price"] intValue];
    
    self.user_service_anytime = [[dictionary objectForKey:@"any_time"] intValue];
    
    self.startTime = [dictionary objectForKey:@"start_time"];
    self.endTime = [dictionary objectForKey:@"end_time"];
    
    self.aryDates = [[NSMutableArray alloc] init];
    NSString *dates = [dictionary objectForKey:@"days"];
    if(dates.length > 0) {
        NSArray *aryDates = [dates componentsSeparatedByString:@","];
        
        for (int index = 0 ; index < aryDates.count ; index ++) {
            NSString *dates = [aryDates objectAtIndex:index];
            [self.aryDates addObject:dates];
        }
    }
}

@end
