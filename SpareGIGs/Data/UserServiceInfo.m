//
//  UserServiceInfo.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "UserServiceInfo.h"

#import "Constants.h"
#import "DataManager.h"

#import "MyServiceDetailTAbleViewCell.h"
#import "ScheduleTableViewCell.h"

@implementation UserServiceInfo

- (id) init
{
	if ( (self = [super init]) )
	{
        [self _init];
	}
	
	return self;
}

- (id) initWithUserId:(NSString *)userid serviceId:(NSString *)serviceid serviceName:(NSString *)serviceName
{
    if ( (self = [super init]) )
    {
        [self _init];
        
        self.user_id = userid;
        
        self.service_id = serviceid;
        self.service_name = serviceName;
    }
    
    return self;
}

- (void) _init
{
    self.user_service_id = @"";
    self.user_id = @"";
    
    self.service_id = @"";
    self.service_name = @"";
    
    self.service_description = @"";
    self.service_radius = 5;
    
    self.service_more_info = @"";
    
    self.service_schedule = [[NSMutableArray alloc] init];
    
//    UserServiceScheduleInfo *schedule = [[UserServiceScheduleInfo alloc] init];
//    [self.service_schedule addObject:schedule];
}

- (float) getServiceCellHeight:(float) width
{
    float height = CELL_SCHEDULE_HEIGHT * self.service_schedule.count;
    
    return height += [self getServiceDescriptionHeight:width];
}

- (float) getServiceDescriptionHeight:(float) width
{
    float height = 30.0f;
    UIFont *font = [UIFont fontWithName:@"Lato" size:14.0f];
    
    CGSize expectedLabelSize = [self.service_description sizeWithFont:font
                                                    constrainedToSize:CGSizeMake(width, 1000)
                                                        lineBreakMode:NSLineBreakByCharWrapping];
    
    height = MAX(30.0f, expectedLabelSize.height);
    
    return height;
}

- (UserServiceInfo *) clone
{
    UserServiceInfo *userServiceInfo = [[UserServiceInfo alloc] initWithUserId:self.user_id serviceId:self.service_id serviceName:self.service_name];
    
    userServiceInfo.user_service_id = self.user_service_id;
    
    userServiceInfo.service_description = self.service_description;
    userServiceInfo.service_radius = self.service_radius;
    
    userServiceInfo.service_more_info = self.service_more_info;
    
    userServiceInfo.service_schedule = [[NSMutableArray alloc] init];
    for ( int index = 0 ; index < self.service_schedule.count ; index ++) {
        UserServiceScheduleInfo *schedule = [self.service_schedule objectAtIndex:index];
        [userServiceInfo.service_schedule addObject:[schedule clone]];
    }
    
    return userServiceInfo;
}

- (void) copyDataWith:(UserServiceInfo *)serviceInfo
{
    self.user_service_id = serviceInfo.user_service_id;
    
    self.user_id = serviceInfo.user_id;
    
    self.service_id = serviceInfo.service_id;
    self.service_name = serviceInfo.service_name;
    
    self.service_description = serviceInfo.service_description;
    self.service_radius = serviceInfo.service_radius;
    
    self.service_more_info = serviceInfo.service_more_info;
    
    [self.service_schedule removeAllObjects];
    for ( int index = 0 ; index < serviceInfo.service_schedule.count ; index ++) {
        UserServiceScheduleInfo *schedule = [serviceInfo.service_schedule objectAtIndex:index];
        [self.service_schedule addObject:[schedule clone]];
    }
}

- (NSMutableDictionary *) getDictionary
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:self.user_id forKey:@"user_id"];
    [data setObject:self.user_service_id forKey:@"user_service_id"];
    [data setObject:self.service_id forKey:@"service_id"];
    [data setObject:self.service_name forKey:@"service_name"];
    [data setObject:self.service_description forKey:@"description"];
    [data setObject:[NSNumber numberWithInt:self.service_radius] forKey:@"radius"];
    [data setObject:self.service_more_info forKey:@"more_info"];
    
    NSMutableArray *arySchedules = [[NSMutableArray alloc] init];
    for (int index = 0 ; index < self.service_schedule.count; index ++) {
        UserServiceScheduleInfo *schedule = [self.service_schedule objectAtIndex:index];
        
        [arySchedules addObject:[schedule getDictionaryData]];
    }
    
    [data setObject:arySchedules forKey:@"service_schedule"];
    
    return data;
}

- (void) setDataWithDictionary:(NSDictionary *)dictionary
{
    self.user_id = [dictionary objectForKey:@"user_id"];
    self.user_service_id = [dictionary objectForKey:@"_id"];
    
    self.service_id = [dictionary objectForKey:@"service_id"];
    self.service_name = [dictionary objectForKey:@"service_name"];
    
    self.service_description = [dictionary objectForKey:@"description"];
    self.service_radius = [[dictionary objectForKey:@"radius"] intValue];
    
    self.service_more_info = [dictionary objectForKey:@"more_info"];
    
    self.service_schedule = [[NSMutableArray alloc] init];
    
    NSArray *arySchedules = [dictionary objectForKey:@"service_schedule"];
    if([arySchedules isKindOfClass:[NSArray class]]) {
        for ( int index = 0 ; index < arySchedules.count ; index ++) {
            NSDictionary *schedule = [arySchedules objectAtIndex:index];
            
            UserServiceScheduleInfo *scheduleInfo = [[UserServiceScheduleInfo alloc] init];
            [scheduleInfo setDataWithDictionary:schedule];
            
            [self.service_schedule addObject:scheduleInfo];
        }
    }
}

@end
