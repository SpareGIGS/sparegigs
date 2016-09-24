//
//  MessageInfo.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "HireInfo.h"

#import "Constants.h"
#import "DataManager.h"

@implementation HireInfo

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
    self.hireId = @"";
    
    self.hiredDate = @"";
    
    self.client = nil;
    self.provider = nil;
    
    self.price = 20;
    
    self.contactTerm = @"";
    self.startDate = @"";
    self.endDate = @"";
    
    self.roomId = @"";
    
    self.state = HIRE_STATE_NONE;
    
    self.rating = 0;
    self.review = @"";
}

- (HireInfo *) initWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@", dictionary);
    
    self.hireId = [dictionary objectForKey:@"_id"];
    
    self.hiredDate = [dictionary objectForKey:@"_id"];
    
    self.client = [[UserInfo alloc] initWithDictionary:[dictionary objectForKey:@"client"]];
    self.provider = [[UserInfo alloc] initWithDictionary:[dictionary objectForKey:@"provider"]];
    
    self.price = [[dictionary objectForKey:@"rate_price"] integerValue];
    
    self.contactTerm = [dictionary objectForKey:@"contact_term"];
    self.startDate = [dictionary objectForKey:@"start_time"];
    self.endDate = [dictionary objectForKey:@"target_end_time"];
    
    self.roomId = [dictionary objectForKey:@"_id"];
    
    self.state = [[dictionary objectForKey:@"state"] integerValue];
    
    self.rating = [[dictionary objectForKey:@"rate"] integerValue];
    self.review = [dictionary objectForKey:@"review"];
    
    return self;
}

- (NSDictionary *) getDictionary
{
    NSDictionary *info = @{@"client_id" : self.client.userid,
                           @"provider_id" : self.provider.userid,
                           @"rate_price" : [NSNumber numberWithInteger:self.price],
                           @"contact_term" : self.contactTerm,
                           @"start_date" : self.startDate,
                           @"target_end_date" : self.endDate,
                           @"room_id" : self.roomId,
                                  };
    
    return info;
}

- (UserInfo *) getOpportunity
{
    if([self.client.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
        return self.provider;
    }
    
    return self.client;
}

- (BOOL) isClient
{
    if([self.client.userid isEqualToString:[DataManager shareDataManager].user.userid]) {
        return YES;
    }
    
    return NO;
}

@end
