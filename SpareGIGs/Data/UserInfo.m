//
//  UserInfo.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "UserInfo.h"

#import "Constants.h"

#import "DataManager.h"

@implementation UserInfo

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
    self.userid = @"";
    
    self.profile = @"";
    self.username = @"";
    
    self.email = @"";
    self.pwd = @"";
    
    self.location = @"";
    
    self.phone = @"";
    self.businessphone = @"";
    
    self.rate = 0;
    
    self.socialType = 0;
}

- (UserInfo *) initFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.userid = [userDefaults objectForKey:USER_ID];
    
    self.profile = [userDefaults objectForKey:USER_PROFILE];
    self.username = [userDefaults objectForKey:USER_NAME];
    
    self.email = [userDefaults objectForKey:USER_EMAIL];
    self.pwd = [userDefaults objectForKey:USER_PASSWORD];
    
    self.location = [userDefaults objectForKey:USER_LOCATION];
    
    self.phone = [userDefaults objectForKey:USER_PHONE];
    self.businessphone = [userDefaults objectForKey:USER_BUSINESS_PHONE];
    
    self.rate = [userDefaults integerForKey:USER_RATE];
    
    self.socialType = [userDefaults integerForKey:USER_SOCIAL_TYPE];
    
    return self;
}

- (UserInfo *) initWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@", dictionary);
    
    self.userid = [dictionary objectForKey:@"user_id"];
    
    self.profile = [dictionary objectForKey:@"profile_url"];
    self.username = [dictionary objectForKey:@"user_name"];
    
    self.email = [dictionary objectForKey:@"user_email"];
    self.pwd = [dictionary objectForKey:@"user_pswd"];
    
    self.location = [dictionary objectForKey:@"zip_code"];
    
    self.phone = [dictionary objectForKey:@"phone_num"];
    self.businessphone = [dictionary objectForKey:@"business_phone"];
    
    self.rate = [[dictionary objectForKey:@"rate"] intValue];
    
    self.socialType = [[dictionary objectForKey:@"social_type"] intValue];
    
    return self;
}

- (void) save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userid forKey:USER_ID];
    [userDefaults setObject:self.profile forKey:USER_PROFILE];
    [userDefaults setObject:self.username forKey:USER_NAME];
    [userDefaults setObject:self.email forKey:USER_EMAIL];
    [userDefaults setObject:self.pwd forKey:USER_PASSWORD];
    [userDefaults setObject:self.location forKey:USER_LOCATION];
    [userDefaults setObject:self.phone forKey:USER_PHONE];
    [userDefaults setObject:self.businessphone forKey:USER_BUSINESS_PHONE];
    [userDefaults setInteger:self.rate forKey:USER_RATE];
    [userDefaults setInteger:self.socialType forKey:USER_SOCIAL_TYPE];
    
    [userDefaults synchronize];
}

- (void) clear
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:USER_ID];
    [userDefaults setObject:nil forKey:USER_PROFILE];
    [userDefaults setObject:nil forKey:USER_NAME];
    [userDefaults setObject:nil forKey:USER_EMAIL];
    [userDefaults setObject:nil forKey:USER_PASSWORD];
    [userDefaults setObject:nil forKey:USER_LOCATION];
    [userDefaults setObject:nil forKey:USER_PHONE];
    [userDefaults setObject:nil forKey:USER_BUSINESS_PHONE];
    [userDefaults setInteger:0 forKey:USER_RATE];
    [userDefaults setInteger:0 forKey:USER_SOCIAL_TYPE];
    
    [userDefaults synchronize];
}

- (BOOL) isCompleted
{
    if(![DataManager NSStringIsValidEmail:self.email]) return NO;
    
    if(self.userid.length > 0 &&
       self.username.length > 0 &&
       self.email.length > 0 &&
       self.location.length > 0 &&
       self.phone.length > 0 ) {
        return YES;
    }
    
    return NO;
}

@end
