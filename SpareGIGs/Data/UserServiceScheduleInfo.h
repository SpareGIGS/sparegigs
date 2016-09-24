//
//  UserServiceScheduleInfo.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    SERVICE_MON = 1,
    SERVICE_TUE,
    SERVICE_WED,
    SERVICE_THU,
    SERVICE_FRI,
    SERVICE_SAT,
    SERVICE_SUN,
};

@interface UserServiceScheduleInfo : NSObject

@property (nonatomic, retain) NSString *user_service_schedule_id;
@property (nonatomic, retain) NSString *user_service_id;

@property (nonatomic, assign) int user_service_rate;

@property (nonatomic, assign) int user_service_anytime;

@property (nonatomic, retain) NSMutableArray *aryDates;

@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;

- (UserServiceScheduleInfo *) clone;
- (void) copyWithData:(UserServiceScheduleInfo *)schedule;

- (NSMutableDictionary *) getDictionaryData;
- (void) setDataWithDictionary:(NSDictionary *)dictionary;

@end
