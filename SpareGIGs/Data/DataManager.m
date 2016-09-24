//
//  DataManager.m
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import "DataManager.h"

#import "Constants.h"

#import "AppDelegate.h"


@implementation DataManager

static DataManager *_shareDataManager;

+ (DataManager *)shareDataManager
{
    @synchronized(self) {
        
        if(_shareDataManager == nil)
        {
            _shareDataManager = [[DataManager alloc] init];
            
            
        }
    }
    
    return _shareDataManager;
}

+ (void)releaseDataManager
{
    if(_shareDataManager != nil)
    {
        _shareDataManager = nil;
    }
}

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
    self.searchFilterInfo = [[SearchFilterInfo alloc] init];
}

- (void) passedMakeMoney
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:READ_MAKE_MONEY forKey:READ_MAKE_MONEY];
    
    [userDefaults synchronize];
}

- (BOOL)isPassedMakeMoney
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:READ_MAKE_MONEY] != nil;
}

- (BOOL) isSignup
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isSignUp = [userDefaults objectForKey:USER_SIGNUP];
    
    return isSignUp;
}

- (void) setSignup
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:USER_SIGNUP];
    
    [userDefaults synchronize];
}

- (BOOL) isSignin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userid = [userDefaults objectForKey:USER_ID];
    
    return userid != nil;
}

- (void) login:(UserInfo *)user
{
    [self setSignup];
    
    self.user = user;
    [self.user save];
}

- (void) logout
{
    if(self.user != nil) {
        [self.user clear];
        self.user = nil;
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:USER_ID];
        [userDefaults setObject:nil forKey:USER_EMAIL];
        [userDefaults setObject:nil forKey:USER_ZIP];
        [userDefaults setObject:nil forKey:USER_PHONE];
        
        [userDefaults synchronize];
    }
}

- (void) updateUser:(UserInfo *)user
{
    [self login:user];
}

- (void) clearUserInformation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:USER_SIGNUP];
    [userDefaults synchronize];
    
    [self.user clear];
    self.user = nil;
}

- (void) setServices:(NSArray *)aryServices
{
    self.aryServices = aryServices;
}

- (void) addMyService:(UserServiceInfo *)userService
{
    if(self.aryMyServices == nil) {
        self.aryMyServices = [[NSMutableArray alloc] init];
    }
    
    if(userService == nil) return;
    
    [self.aryMyServices addObject:userService];
}

- (BOOL) checkMyServiceWithId:(NSString *)serviceId
{
    if(serviceId == nil || serviceId.length == 0) return NO;
    
    if(self.aryMyServices == nil || self.aryMyServices.count == 0) return NO;
    
    for (int index = 0 ; index < self.aryMyServices.count ; index ++) {
        UserServiceInfo *serviceInfo = [self.aryMyServices objectAtIndex:index];
        
        if([serviceInfo.service_id isEqualToString:serviceId]) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (NSString *) getDatesString:(NSArray *)aryDates
{
    NSString *strDates = @"";
    for (int index = 0 ; index < aryDates.count ; index ++) {
        int date = [[aryDates objectAtIndex:index] intValue];
        NSString *dateString = [self getDateString:date];
        
        if(strDates.length == 0) {
            strDates = dateString;
        } else {
            strDates = [NSString stringWithFormat:@"%@,%@", strDates, dateString];
        }
    }
    
    if(strDates.length == 0) strDates = @"Any Days";
    
    return strDates;
}

+ (NSString *) getDateString:(int) date
{
    NSString *dateString = @"";
    
    switch (date) {
        case SERVICE_MON:
            dateString = @"Monday";
            break;
            
        case SERVICE_TUE:
            dateString = @"Tuesday";
            break;
            
        case SERVICE_WED:
            dateString = @"Wednesday";
            break;
            
        case SERVICE_THU:
            dateString = @"Thursday";
            break;
            
        case SERVICE_FRI:
            dateString = @"Friday";
            break;
            
        case SERVICE_SAT:
            dateString = @"Saturday";
            break;
            
        case SERVICE_SUN:
            dateString = @"Sunday";
            break;
            
        default:
            break;
    }
    
    return dateString;
}

+ (void) getAddressWithLocation:(CLLocation *)location label:(UILabel *)label
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             
             // strAdd -> take bydefault value nil
             NSString *strAdd = nil;
             
             if ([placemark.subThoroughfare length] != 0)
                 strAdd = placemark.subThoroughfare;
             
             if ([placemark.thoroughfare length] != 0)
             {
                 // strAdd -> store value of current location
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
                 else
                 {
                     // strAdd -> store only this value,which is not null
                     strAdd = placemark.thoroughfare;
                 }
             }
             
             if ([placemark.postalCode length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
                 else
                     strAdd = placemark.postalCode;
             }
             
             if ([placemark.locality length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
                 else
                     strAdd = placemark.locality;
             }
             
             if ([placemark.administrativeArea length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
                 else
                     strAdd = placemark.administrativeArea;
             }
             
             if ([placemark.country length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
                 else
                     strAdd = placemark.country;
             }
             
             label.text = strAdd;
         }
     }];
}

+ (NSDate *) getServerTimeWithLocal:(NSDate *)localTime
{
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString = [dateFormatter stringFromDate:localTime];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:dateFormat];

    NSDate *serverTime = [dateFormatter1 dateFromString:dateString];
    
    return serverTime;
}

+ (NSString *) getLocalTimeWithServer:(NSString *)serverTime
{
    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setTimeZone:inputTimeZone];
    [inputDateFormatter setDateFormat:TIME_FORMAT_SERVER];
    
    NSDate *date = [inputDateFormatter dateFromString:serverTime];
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:TIME_FORMAT_SERVER];
    NSString *localTime = [outputDateFormatter stringFromDate:date];
    
    return localTime;
}

- (NSString *) getAvailableLocation
{
    NSString *location = @"";
    
    if(self.user.location.length > 0) {
        location = self.user.location;
    } else {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        location = [delegate getCurrentPosition];
    }
    
    return location;
}

@end
