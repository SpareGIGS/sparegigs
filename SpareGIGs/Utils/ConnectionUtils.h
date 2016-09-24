//
//  ConnectionUtils.h
//  iOSMDMAgent
//
//  Created by Dilshan Edirisuriya on 3/23/15.
//  Copyright (c) 2015 WSO2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDKProtocol.h"

#import "UserInfo.h"
#import "UserServiceInfo.h"

@interface ConnectionUtils : NSObject

@property(nonatomic, assign) id<SDKProtocol> delegate;

- (void)registerUser:(UserInfo *)user;
- (void)signinWithEmail:(NSString *)email withPwd:(NSString *)pwd;
- (void)signinWithSocial:(NSString *)socialId withEmail:(NSString *)email image:(NSString *)profile  withType:(NSString *)type;
- (void)verifyWithEmail:(NSString *)email withCode:(NSString *)code;
- (void)forgotPwd:(NSString *)email;
- (void) reqUserInfo:(NSString *)userid;
- (void) reqUpdateUserInfo:(UserInfo *)user;
- (void) reqVerifyEmail:(NSString *)userid withEmail:(NSString *)email;
- (void) reqChangePwd:(NSString *)userid old:(NSString *)oldPwd new:(NSString *)newPwd;

- (void) reqAddNewService:(UserServiceInfo *)service;
- (void) getUserService:(NSString *)serviceId;
- (void) reqUpdateUserService:(UserServiceInfo *)service applyAll:(BOOL) applyAll;
- (void) reqDeleteUserService:(NSString *)serviceId;

- (void) getUserServiceList:(NSString *)userid;

- (void) getServices;

- (void) findServicesWith:(NSString *)userid location:(NSString *)location radius:(NSInteger)radius day:(NSString *)day keyword:(NSString *)keyword;

- (void) createRoom:(NSString *)clientId provider:(NSString *)providerId serviceId:(NSString *)serviceId title:(NSString *)serviceName;
- (void) getRooms:(NSString *)userid;

- (void) sendMessage:(NSString *)roomId user:(NSString *)userId message:(NSString *)message;
- (void) getMessages:(NSString *)roomId last:(NSString *)lastTime;

- (void) createOffer:(NSDictionary *)offer;
- (void) updateOffer:(NSString *)offerId state:(int)state;
- (void) writeReview:(NSString *)offerId state:(int)state review:(NSString *)review rating:(NSInteger)rating;

- (void) getHireHistory:(NSString *)userid;
- (void) getOfferHistory:(NSString *)userid;

- (void) clearHireHistory:(NSString *)userid;
- (void) clearOfferHistory:(NSString *)userid;

- (void) deleteHire:(NSString *)userid offer:(NSString *)offerId;

- (void) addFavorUser:(NSString *)userid opp:(NSString *)favorId;
- (void) getFavorUser:(NSString *)userid;
- (void) deleteFavorUser:(NSString *)userid opp:(NSString *)favorId;
- (void) checkFavorUser:(NSString *)userid opp:(NSString *)favorId;


@end
