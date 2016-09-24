//
//  RoomInfo.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "RoomInfo.h"

#import "Constants.h"
#import "DataManager.h"

@implementation RoomInfo

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

}

- (RoomInfo *) initWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@", dictionary);
    
    self.roomId = [dictionary objectForKey:@"_id"];
    
    NSDictionary *clientInfo = [dictionary objectForKey:@"client"];
    self.client = [[UserInfo alloc] initWithDictionary:clientInfo];
    
    NSDictionary *providerInfo = [dictionary objectForKey:@"provider"];
    self.provider = [[UserInfo alloc] initWithDictionary:providerInfo];
    
    self.serviceId = [dictionary objectForKey:@"service_id"];
    self.serviceName = [dictionary objectForKey:@"service_name"];
    
    self.lastMessageId = [dictionary objectForKey:@"last_msg_id"];
    
    self.isClient = [[DataManager shareDataManager].user.userid isEqualToString:self.client.userid];
    
    return self;
}

- (UserInfo *) getOpportunity
{
    UserInfo * opportunity = nil;
    
    if(self.isClient) {
        opportunity = self.provider;
    } else {
        opportunity = self.client;
    }
    
    return opportunity;
}

- (NSString *) getOpportunityName
{
    NSString *name = @"";
    
    if(self.isClient) {
        name = self.provider.username;
    } else {
        name = self.client.username;
    }
    
    return name;
}

- (NSString *) getOpportunityEmail
{
    NSString *email = @"";
    
    if(self.isClient) {
        email = self.provider.email;
    } else {
        email = self.client.email;
    }
    
    return email;
}

- (NSString *) getOpportunityPhoneNumber
{
    NSString *phoneNumber = @"";
    
    if(self.isClient) {
        phoneNumber = self.provider.phone;
    } else {
        phoneNumber = self.client.phone;
    }
    
    return phoneNumber;
}

@end
