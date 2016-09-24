//
//  HireInfo.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"

@interface HireInfo : NSObject

@property (nonatomic, retain) NSString *hireId;

@property (nonatomic, retain) NSString *hiredDate;

@property (nonatomic, retain) UserInfo *client;
@property (nonatomic, retain) UserInfo *provider;

@property (nonatomic, assign) NSInteger price;
@property (nonatomic, retain) NSString *contactTerm;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;

@property (nonatomic, retain) NSString *roomId;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger rating;
@property (nonatomic, retain) NSString *review;

- (HireInfo *) initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *) getDictionary;

- (UserInfo *) getOpportunity;
- (BOOL) isClient;

@end
