//
//  MessageInfo.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MessageInfo.h"

#import "Constants.h"
#import "DataManager.h"

@implementation MessageInfo

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

- (MessageInfo *) initWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@", dictionary);
    
    self.messageId = [dictionary objectForKey:@"_id"];
    self.roomId = [dictionary objectForKey:@"room_id"];
    
    self.msgBody = [dictionary objectForKey:@"msg_body"];
    self.msgTime = [dictionary objectForKey:@"msg_time"];
    
    self.senderId = [dictionary objectForKey:@"sender_id"];
    
    self.offerId = [dictionary objectForKey:@"offer_value"];
    
    NSObject *offerState = [dictionary objectForKey:@"offer_state"];
    
    if(![offerState isKindOfClass:[NSNull class]]) {
        self.offerState = [[dictionary objectForKey:@"offer_state"] integerValue];
    }

    return self;
}

- (BOOL) fromMe
{
    return [self.senderId isEqualToString:[DataManager shareDataManager].user.userid];
}

- (BOOL) isOffer
{
    if([self.offerId isEqualToString:@"0"]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) isPenddingOffer
{
    if(![self isOffer]) {
        return NO;
    }
    
    if(self.offerState == HIRE_STATE_PENDDING) {
        return YES;
    }
    
    return NO;
}

@end
