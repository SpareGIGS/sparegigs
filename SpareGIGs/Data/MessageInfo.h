//
//  MessageInfo.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject

@property (nonatomic, retain) NSString *messageId;
@property (nonatomic, retain) NSString *roomId;

@property (nonatomic, retain) NSString *msgBody;
@property (nonatomic, retain) NSString *msgTime;

@property (nonatomic, retain) NSString *senderId;

@property (nonatomic, retain) NSString *offerId;
@property (nonatomic, assign) NSInteger offerState;

- (MessageInfo *) initWithDictionary:(NSDictionary *)dictionary;

- (BOOL) fromMe;
- (BOOL) isOffer;
- (BOOL) isPenddingOffer;

@end
