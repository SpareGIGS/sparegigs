//
//  ConnectionUtils.m
//  iOSMDMAgent
//
//  Created by Dilshan Edirisuriya on 3/23/15.
//  Copyright (c) 2015 WSO2. All rights reserved.
//

#import "ConnectionUtils.h"
#import "URLUtils.h"

//Remove this code chunk in production
@interface NSURLRequest(Private)

+(void)setAllowsAnyHTTPSCertificate:(BOOL)inAllow forHost:(NSString *)inHost;

@end

@implementation ConnectionUtils

- (void)registerUser:(UserInfo *)user {
    
    NSString *endpoint = [URLUtils getRegisterURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:user.email forKey:@"user_email"];
    [paramDictionary setValue:user.pwd forKey:@"user_pswd"];
    [paramDictionary setValue:user.location forKey:@"zip_code"];
    [paramDictionary setValue:user.phone forKey:@"phone_num"];
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    NSLog(@"register parameter: ------ %@", payload);
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void)signinWithEmail:(NSString *)email withPwd:(NSString *)pwd
{
    NSString *endpoint = [URLUtils getSigninURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:email forKey:@"user_email"];
    [paramDictionary setValue:pwd forKey:@"user_pswd"];
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void)signinWithSocial:(NSString *)socialId withEmail:(NSString *)email image:(NSString *)profile  withType:(NSString *)type
{
    NSString *endpoint = [URLUtils getSocialSigninURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:socialId forKey:@"id"];
    [paramDictionary setValue:email forKey:@"user_email"];
    [paramDictionary setValue:profile forKey:@"profile_image"];
    [paramDictionary setValue:type forKey:@"type"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            NSLog(@"%@", json);
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void)verifyWithEmail:(NSString *)email withCode:(NSString *)code
{
    NSString *endpoint = [URLUtils getVerifyURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:email forKey:@"user_email"];
    [paramDictionary setValue:code forKey:@"v_code"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void)forgotPwd:(NSString *)email
{
    NSString *endpoint = [URLUtils getForgotPwdURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:email forKey:@"user_email"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) reqUserInfo:(NSString *)userid
{
    NSString *endpoint = [URLUtils getGettingUserInfoURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) reqUpdateUserInfo:(UserInfo *)user
{
    NSString *endpoint = [URLUtils getUpdateUserInfoURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:user.userid forKey:@"user_id"];
    [paramDictionary setValue:user.username forKey:@"user_name"];
    [paramDictionary setValue:user.email forKey:@"user_email"];
    [paramDictionary setValue:user.location forKey:@"zip_code"];
    [paramDictionary setValue:user.phone forKey:@"phone_num"];
    [paramDictionary setValue:user.businessphone forKey:@"business_phone"];
    [paramDictionary setValue:user.profile forKey:@"profile_url"];
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) reqVerifyEmail:(NSString *)userid withEmail:(NSString *)email
{
    NSString *endpoint = [URLUtils getReqVerifyURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    [paramDictionary setValue:email forKey:@"user_email"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) reqChangePwd:(NSString *)userid old:(NSString *)oldPwd new:(NSString *)newPwd
{
    NSString *endpoint = [URLUtils getChangePwdURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    [paramDictionary setValue:oldPwd forKey:@"current_pswd"];
    [paramDictionary setValue:newPwd forKey:@"new_pswd"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getServices
{
    NSString *endpoint = [URLUtils getGetServicesURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    [request setHTTPMethod:GET];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) reqAddNewService:(UserServiceInfo *)service
{
    NSString *endpoint = [URLUtils getInsertUserServiceURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [service getDictionary];
    
    NSLog(@"%@", paramDictionary);
    
    NSData *requestData = [[self dictionaryToJSON:paramDictionary] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *lengthString = [NSString stringWithFormat:@"%ld", [requestData length]];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:requestData];
    [request setValue:lengthString forHTTPHeaderField:@"Content-Length"];
    [self setContentType:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getUserService:(NSString *)serviceId
{
    NSString *endpoint = [URLUtils getGetUserServiceURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:serviceId forKey:@"user_service_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) reqUpdateUserService:(UserServiceInfo *)service applyAll:(BOOL) applyAll
{
    NSString *endpoint = [URLUtils getUpdateUserServiceURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [service getDictionary];
    [paramDictionary setObject:(applyAll ? @"1" : @"0") forKey:@"apply_to_all"];
    
    NSLog(@"%@", paramDictionary);
    
    NSData *requestData = [[self dictionaryToJSON:paramDictionary] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *lengthString = [NSString stringWithFormat:@"%ld", [requestData length]];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:requestData];
    [request setValue:lengthString forHTTPHeaderField:@"Content-Length"];
    [self setContentType:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) reqDeleteUserService:(NSString *)serviceId
{
    NSString *endpoint = [URLUtils getDeleteUserServiceURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:serviceId forKey:@"user_service_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getUserServiceList:(NSString *)userid
{
    NSString *endpoint = [URLUtils getGetUserServiceListURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) findServicesWith:(NSString *)userid location:(NSString *)location radius:(NSInteger)radius day:(NSString *)day keyword:(NSString *)keyword
{
    NSString *endpoint = [URLUtils getFindServicesURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    [paramDictionary setValue:location forKey:@"zip_code"];
    [paramDictionary setValue:[NSNumber numberWithInteger:radius] forKey:@"radius"];
    [paramDictionary setValue:day forKey:@"days"];
    [paramDictionary setValue:keyword forKey:@"keyword"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) createRoom:(NSString *)clientId provider:(NSString *)providerId serviceId:(NSString *)serviceId title:(NSString *)serviceName
{
    NSString *endpoint = [URLUtils getCreateRoomURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:clientId forKey:@"client_id"];
    [paramDictionary setValue:providerId forKey:@"provider_id"];
    [paramDictionary setValue:serviceId forKey:@"service_id"];
    [paramDictionary setValue:serviceName forKey:@"service_name"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getRooms:(NSString *)userid
{
    NSString *endpoint = [URLUtils getGetRoomsURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) sendMessage:(NSString *)roomId user:(NSString *)userId message:(NSString *)message
{
    NSString *endpoint = [URLUtils getSendMessageURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:roomId forKey:@"room_id"];
    [paramDictionary setValue:userId forKey:@"user_id"];
    [paramDictionary setValue:message forKey:@"body"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getMessages:(NSString *)roomId last:(NSString *)lastTime
{
    NSString *endpoint = [URLUtils getGetMessagesURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:roomId forKey:@"room_id"];
    [paramDictionary setValue:lastTime forKey:@"last_get_time"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) createOffer:(NSDictionary *)offer
{
    NSString *endpoint = [URLUtils getCreateOfferURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSLog(@"%@", offer);
    
    NSString *payload = [self dictionaryToString:offer];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) updateOffer:(NSString *)offerId state:(int)state
{
    NSString *endpoint = [URLUtils getUpdateOfferURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:offerId forKey:@"offer_id"];
    [paramDictionary setValue:[NSNumber numberWithInt:state] forKey:@"state"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) writeReview:(NSString *)offerId state:(int)state review:(NSString *)review rating:(NSInteger)rating
{
    NSString *endpoint = [URLUtils getUpdateOfferURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:offerId forKey:@"offer_id"];
    [paramDictionary setValue:[NSNumber numberWithInt:state] forKey:@"state"];
    [paramDictionary setValue:review forKey:@"review"];
    [paramDictionary setValue:[NSNumber numberWithInt:rating] forKey:@"rate"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getHireHistory:(NSString *)userid
{
    NSString *endpoint = [URLUtils getGetHireHistoryURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getOfferHistory:(NSString *)userid
{
    NSString *endpoint = [URLUtils getGetOfferHistoryURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) clearHireHistory:(NSString *)userid
{
    NSString *endpoint = [URLUtils getClearHireHistoryURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) clearOfferHistory:(NSString *)userid
{
    NSString *endpoint = [URLUtils getClearOfferHistoryURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) deleteHire:(NSString *)userid offer:(NSString *)offerId
{
    NSString *endpoint = [URLUtils getDeleteHireURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    [paramDictionary setValue:offerId forKey:@"offer_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) addFavorUser:(NSString *)userid opp:(NSString *)favorId
{
    NSString *endpoint = [URLUtils getAddFavorURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    [paramDictionary setValue:favorId forKey:@"favor_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) getFavorUser:(NSString *)userid
{
    NSString *endpoint = [URLUtils getGetFavorURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) deleteFavorUser:(NSString *)userid opp:(NSString *)favorId
{
    NSString *endpoint = [URLUtils getDeleteFavorURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    [paramDictionary setValue:favorId forKey:@"favor_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void) checkFavorUser:(NSString *)userid opp:(NSString *)favorId
{
    NSString *endpoint = [URLUtils getCheckFavorURL];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_REQUEST_TIME];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setValue:userid forKey:@"user_id"];
    [paramDictionary setValue:favorId forKey:@"favor_id"];
    
    NSLog(@"%@", paramDictionary);
    
    NSString *payload = [self dictionaryToString:paramDictionary];
    
    [request setHTTPMethod:POST];
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setContentTypeFormEncoded:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        int code = (int)[(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"Error occurred %i", code);
        if (code == HTTP_OK) {
            NSError *jsonError;
            NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *objectData = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            
            if([_delegate respondsToSelector:@selector(unregisterSuccessful:)]){
                [_delegate unregisterSuccessful:json];
            }
        }
        else {
            
            if([_delegate respondsToSelector:@selector(unregisterFailure:)]){
                [_delegate unregisterFailure:error];
            }
        }
    }];
}

- (void)setContentType:(NSMutableURLRequest *)request {
    [request setValue:APPLICATION_JSON forHTTPHeaderField:CONTENT_TYPE];
    [request setValue:APPLICATION_JSON forHTTPHeaderField:ACCEPT];
}

- (void)setContentTypeFormEncoded:(NSMutableURLRequest *)request {
    [request setValue:FORM_ENCODED forHTTPHeaderField:CONTENT_TYPE];
}


- (void)setAllowsAnyHTTPSCertificate:(NSURL *)url {
    //remove this code chunk in production
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
}

-(NSString *)dictionaryToJSON:(NSDictionary *)dictionary {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

- (NSString *)dictionaryToString:(NSDictionary *)dictionary {
    
    NSString *result = @"";
    
    NSArray *keys = [dictionary allKeys];
    for (int index = 0 ; index < [keys count]; index ++) {
        NSString *key = keys[index];
        NSString *value = [dictionary objectForKey:key];
        
        NSString *oneField = [NSString stringWithFormat:@"%@=%@", key, value];
        
        if(result.length > 0) result = [NSString stringWithFormat:@"%@&", result];
        
        result = [NSString stringWithFormat:@"%@%@", result, oneField];
    }
    
    return result;
}

-(NSString *)arrayToJSON:(NSArray *)array {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

@end
