//
//  URLUtils.h
//  iOSMDMAgent
//
//  Created by Dilshan Edirisuriya on 3/23/15.
//  Copyright (c) 2015 WSO2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtils : NSObject

extern float const HTTP_REQUEST_TIME;

extern int HTTP_OK;
extern int HTTP_CREATED;

extern int OAUTH_FAIL_CODE;

extern NSString *const GET;
extern NSString *const POST;
extern NSString *const PUT;

extern NSString *const ACCEPT;
extern NSString *const CONTENT_TYPE;
extern NSString *const APPLICATION_JSON;
extern NSString *const FORM_ENCODED;

extern NSString *const LATITIUDE;
extern NSString *const LONGITUDE;

+ (NSString *)getRegisterURL;
+ (NSString *)getSigninURL;
+ (NSString *)getSocialSigninURL;
+ (NSString *)getVerifyURL;
+ (NSString *)getForgotPwdURL;
+ (NSString *)getGettingUserInfoURL;
+ (NSString *)getUpdateUserInfoURL;
+ (NSString *)getReqVerifyURL;

+ (NSString *)getChangePwdURL;

+ (NSString *)getGetServicesURL;
+ (NSString *)getInsertUserServiceURL;
+ (NSString *)getGetUserServiceURL;
+ (NSString *)getUpdateUserServiceURL;
+ (NSString *)getDeleteUserServiceURL;
+ (NSString *)getGetUserServiceListURL;

+ (NSString *)getFindServicesURL;

+ (NSString *)getCreateRoomURL;
+ (NSString *)getGetRoomsURL;
+ (NSString *)getSendMessageURL;
+ (NSString *)getGetMessagesURL;

+ (NSString *)getCreateOfferURL;
+ (NSString *)getUpdateOfferURL;

+ (NSString *)getGetHireHistoryURL;
+ (NSString *)getGetOfferHistoryURL;

+ (NSString *)getClearHireHistoryURL;
+ (NSString *)getClearOfferHistoryURL;
+ (NSString *)getDeleteHireURL;

+ (NSString *)getAddFavorURL;
+ (NSString *)getGetFavorURL;
+ (NSString *)getDeleteFavorURL;
+ (NSString *)getCheckFavorURL;

@end
