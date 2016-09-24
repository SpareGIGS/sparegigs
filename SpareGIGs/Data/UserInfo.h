//
//  UserInfo.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, retain) NSString *userid;

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *profile;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *pwd;

@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *businessphone;

@property (nonatomic, retain) NSString *location;

@property (nonatomic, assign) NSInteger rate ;

@property (nonatomic, assign) NSInteger socialType ;

- (UserInfo *) initFromLocal;
- (UserInfo *) initWithDictionary:(NSDictionary *)dictionary;

- (void) save;
- (void) clear;

- (BOOL) isCompleted;

@end
