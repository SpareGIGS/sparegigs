//
//  DataManager.h
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Constants.h"

#import "UserInfo.h"
#import "UserServiceInfo.h"
#import "SearchFilterInfo.h"

#import <CoreLocation/CoreLocation.h>

@interface DataManager : NSObject
{
    
}

@property (nonatomic, retain) UserInfo *user;

@property (nonatomic, retain) SearchFilterInfo *searchFilterInfo;

@property (nonatomic, retain) NSArray *aryServices; // with json format from server
@property (nonatomic, retain) NSMutableArray *aryMyServices; // with UserServiceInfo

+ (DataManager *)shareDataManager;
+ (void)releaseDataManager;

- (void) passedMakeMoney;
- (BOOL)isPassedMakeMoney;

- (BOOL) isSignup;
- (void) setSignup;
- (BOOL) isSignin;

- (void) login:(UserInfo *)user;
- (void) logout;

- (void) updateUser:(UserInfo *)user;

- (void) clearUserInformation;

- (void) setServices:(NSArray *)aryServices; // with json format from server

- (void) addMyService:(UserServiceInfo *)userService;

- (BOOL) checkMyServiceWithId:(NSString *)serviceId;

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (NSString *) getDatesString:(NSArray *)aryDates;

+ (void) getAddressWithLocation:(CLLocation *)location label:(UILabel *)label;

+ (NSString *) getLocalTimeWithServer:(NSString *)serverTime;

- (NSString *) getAvailableLocation;

@end
