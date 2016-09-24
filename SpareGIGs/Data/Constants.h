//
//  Constants.h
//  SpareGIGs
//
//  Created by hanjinghe on 9/12/16.
//  Copyright (c) . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSString *const APP_NAME;

extern NSString *const READ_MAKE_MONEY;

extern NSString *const CONTACT_EMAIL;

extern NSString *const USER_SIGNUP;

extern NSString *const USER_ID;

extern NSString *const USER_NAME;
extern NSString *const USER_PROFILE;

extern NSString *const USER_EMAIL;
extern NSString *const USER_PASSWORD;
extern NSString *const USER_ZIP;
extern NSString *const USER_LOCATION;
extern NSString *const USER_PHONE;

extern NSString *const USER_BUSINESS_PHONE;
extern NSString *const USER_RATE;

extern NSString *const USER_SOCIAL_TYPE;

extern NSString *const SEARCH_FILTERS;
extern NSString *const SEARCH_KEYWORD;
extern NSString *const SEARCH_LOCATION;
extern NSString *const SEARCH_DATE;
extern NSString *const SEARCH_DISTANCE;

extern NSString *const TIME_FORMAT;
extern NSString *const TIME_FORMAT_SERVER;
extern NSString *const SEARCH_DATE_FORMAT;

extern NSString *const PLACEHOLD_SERVICE_DESCRIPTION;
extern NSString *const PLACEHOLD_TYPE_MESSAGE;

extern int const PWD_MIN_LENGTH;

enum {
  LOGIN_WITH_FACEBOOK = 1,
    LOGIN_WITH_TWITTER,
    LOGIN_WITH_GOOGLE
};

enum {
    HIRE_STATE_NONE,
    HIRE_STATE_PENDDING,
    HIRE_STATE_DECLINED,
    HIRE_STATE_ACCEPTED,
    HIRE_STATE_REVIED,
};

enum {
    FAVOR_STATE_NONE,
    FAVOR_STATE_FAVORITE,
    FAVOR_STATE_UNFAVORITE,
};

enum {
    REQ_NONE,
};

// for provided service screen
enum {
    REQ_SERVICE_LIST = 100,
    REQ_ADD_SERVICE
};

// for service detail screen
enum {
    REQ_UPDATE_SERVICE = 200,
    REQ_DELETE_SERVICE
};

// for search service screen
enum {
    REQ_FIND_SERVICES = 300,
    REQ_CREATE_ROOM
};

// for message screen
enum {
    REQ_GET_MESSAGES = 400,
    REQ_SEND_MESSAGE
};

// for hire provider screen
enum {
    REQ_HIRE_SUBMIT_OFFER = 500,
    REQ_HIRE_UPDATE_OFFER,
    REQ_HIRE_DELETE
};

// for hire history screen
enum {
    REQ_GET_HIRE_HISTORY = 600,
    REQ_CLEAR_HIRE_HISTORY,
};

// for user profile screen
enum {
    REQ_CHECK_FAVOR = 700,
    REQ_ADD_FAVOR,
    REQ_REMOVE_FAVOR
};


@end
