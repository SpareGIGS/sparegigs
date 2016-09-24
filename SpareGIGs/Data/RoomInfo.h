//
//  RoomInfo.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"

@interface RoomInfo : NSObject

@property (nonatomic, retain) NSString *roomId;

@property (nonatomic, retain) UserInfo *client;
@property (nonatomic, retain) UserInfo *provider;

@property (nonatomic, retain) NSString *serviceId;
@property (nonatomic, retain) NSString *serviceName;

@property (nonatomic, retain) NSString *lastMessageId;

@property (nonatomic, assign) BOOL isClient;

- (RoomInfo *) initWithDictionary:(NSDictionary *)dictionary;

- (UserInfo *) getOpportunity;
- (NSString *) getOpportunityName;
- (NSString *) getOpportunityEmail;
- (NSString *) getOpportunityPhoneNumber;

@end
