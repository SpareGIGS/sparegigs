//
//  URLUtils.m
//  iOSMDMAgent
//
//  Created by Dilshan Edirisuriya on 3/23/15.
//  Copyright (c) 2015 WSO2. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils

float const HTTP_REQUEST_TIME = 60.0f;

int HTTP_OK = 200;
int HTTP_CREATED = 201;
int OAUTH_FAIL_CODE = 401;

NSString *const SERVER_URL = @"http://ec2-54-70-84-252.us-west-2.compute.amazonaws.com";

NSString *const REGISTER_URI = @"/signup";
NSString *const SIGNIN_URI = @"/login";
NSString *const SOCIAL_SIGNIN_URI = @"/social_login";
NSString *const VERIFY_URI = @"/verification";
NSString *const FORGOT_PWD_URI = @"/forgetpwd";
NSString *const GET_USER_URI = @"/get_user";
NSString *const UPDATE_USER_URI = @"/update_user";
NSString *const REQ_VERIFY_URI = @"/email_verify";
NSString *const CHANGE_PWD_URI = @"/change_password";

NSString *const GET_SERVICES_URI = @"/get_services";
NSString *const INSERT_USER_SERVICE_URI = @"/insert_user_service";
NSString *const GET_USER_SERVICE_URI = @"/get_user_service";
NSString *const UPDATE_USER_SERVICE_URI = @"/update_user_service";
NSString *const DELETE_USER_SERVICE_URI = @"/delete_user_service";
NSString *const GET_USER_SERVICES_URI = @"/get_user_service_total";

NSString *const FIND_SERVICES_URI = @"/find_services";

NSString *const CREATE_ROOM_URI = @"/create_room";
NSString *const GET_ROOMS_URI = @"/get_rooms";
NSString *const SEND_MESSAGE_URI = @"/send_message";
NSString *const GET_MESSAGES_URI = @"/get_messages";

NSString *const CREATE_OFFER_URI = @"/create_offer";
NSString *const UPDATE_OFFER_URI = @"/update_offer";

NSString *const HIRE_HISTORY_URI = @"/hire_history";
NSString *const OFFER_HISTORY_URI = @"/offer_history";

NSString *const CLEAR_OFFER_HISTORY_URI = @"/offer_history_clean";
NSString *const CLEAR_HIRE_HISTORY_URI = @"/hire_history_clean";
NSString *const DELETE_HIRE_URI = @"/history_delete";

NSString *const ADD_FAVOR_URI = @"/add_favor";
NSString *const GET_FAVOR_URI = @"/get_favor";
NSString *const DELETE_FAVOR_URI = @"/delete_favor";
NSString *const CHECK_FAVOR_URI = @"/check_favor";

NSString *const GET = @"GET";
NSString *const POST = @"POST";
NSString *const PUT = @"PUT";

NSString *const ACCEPT = @"Accept";
NSString *const CONTENT_TYPE = @"Content-Type";
NSString *const APPLICATION_JSON = @"application/json";
NSString *const FORM_ENCODED = @"application/x-www-form-urlencoded";

NSString *const LATITIUDE = @"latitude";
NSString *const LONGITUDE = @"longitude";



+ (NSString *)getRegisterURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, REGISTER_URI];
}

+ (NSString *)getSigninURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, SIGNIN_URI];
}

+ (NSString *)getSocialSigninURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, SOCIAL_SIGNIN_URI];
}

+ (NSString *)getVerifyURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, VERIFY_URI];
}

+ (NSString *)getForgotPwdURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, FORGOT_PWD_URI];
}

+ (NSString *)getGettingUserInfoURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_USER_URI];
}

+ (NSString *)getUpdateUserInfoURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, UPDATE_USER_URI];
}

+ (NSString *)getReqVerifyURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, REQ_VERIFY_URI];
}

+ (NSString *)getGetServicesURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_SERVICES_URI];
}

+ (NSString *)getInsertUserServiceURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, INSERT_USER_SERVICE_URI];
}

+ (NSString *)getGetUserServiceURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_USER_SERVICE_URI];
}

+ (NSString *)getUpdateUserServiceURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, UPDATE_USER_SERVICE_URI];
}

+ (NSString *)getDeleteUserServiceURL {
    
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, DELETE_USER_SERVICE_URI];
}

+ (NSString *)getGetUserServiceListURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_USER_SERVICES_URI];
}

+ (NSString *)getFindServicesURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, FIND_SERVICES_URI];
}

+ (NSString *)getCreateRoomURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, CREATE_ROOM_URI];
}

+ (NSString *)getGetRoomsURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_ROOMS_URI];
}

+ (NSString *)getSendMessageURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, SEND_MESSAGE_URI];
}

+ (NSString *)getGetMessagesURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_MESSAGES_URI];
}

+ (NSString *)getCreateOfferURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, CREATE_OFFER_URI];
}

+ (NSString *)getUpdateOfferURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, UPDATE_OFFER_URI];
}

+ (NSString *)getGetHireHistoryURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, HIRE_HISTORY_URI];
}

+ (NSString *)getGetOfferHistoryURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, OFFER_HISTORY_URI];
}

+ (NSString *)getClearHireHistoryURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, CLEAR_HIRE_HISTORY_URI];
}

+ (NSString *)getClearOfferHistoryURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, CLEAR_OFFER_HISTORY_URI];
}

+ (NSString *)getDeleteHireURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, DELETE_HIRE_URI];
}

+ (NSString *)getAddFavorURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, ADD_FAVOR_URI];
}

+ (NSString *)getGetFavorURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_FAVOR_URI];
}

+ (NSString *)getDeleteFavorURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, DELETE_FAVOR_URI];
}

+ (NSString *)getCheckFavorURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, CHECK_FAVOR_URI];
}

+ (NSString *)getChangePwdURL {
    return [NSString stringWithFormat:@"%@%@", SERVER_URL, CHANGE_PWD_URI];
}

@end
