//
//  UserServiceInfo.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserServiceScheduleInfo.h"

@interface UserServiceInfo : NSObject

@property (nonatomic, retain) NSString *user_service_id;
@property (nonatomic, retain) NSString *user_id;

@property (nonatomic, retain) NSString *service_id;
@property (nonatomic, retain) NSString *service_name;

@property (nonatomic, retain) NSString *service_description;
@property (nonatomic, assign) int service_radius;

@property (nonatomic, retain) NSString *service_more_info;

@property (nonatomic, retain) NSMutableArray *service_schedule;

- (id) initWithUserId:(NSString *)userid serviceId:(NSString *)serviceid serviceName:(NSString *)serviceName;

- (float) getServiceDescriptionHeight:(float) width;
- (float) getServiceCellHeight:(float) width;

- (UserServiceInfo *) clone;
- (void) copyDataWith:(UserServiceInfo *)serviceInfo;

- (NSMutableDictionary *) getDictionary;
- (void) setDataWithDictionary:(NSDictionary *)dictionary;

@end
