//
//  SearchFilterInfo.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "SearchFilterInfo.h"

#import "Constants.h"
#import "DataManager.h"

@implementation SearchFilterInfo

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
    self.keyword = @"";
    self.location = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:SEARCH_DATE_FORMAT];
    self.date = [dateFormatter stringFromDate:[NSDate date]];
    
    self.distance = 5;
    
    [self initFromLocal];
}

- (void) initFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *filterSearch = [userDefaults objectForKey:SEARCH_FILTERS];
    
    if(filterSearch != nil) {
        self.keyword = [userDefaults objectForKey:SEARCH_KEYWORD];
        
        self.location = [userDefaults objectForKey:SEARCH_LOCATION];
        self.date = [userDefaults objectForKey:SEARCH_DATE];
        
        self.distance = [userDefaults integerForKey:SEARCH_DISTANCE];
    }
}

- (void) save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:SEARCH_FILTERS forKey:SEARCH_FILTERS];
    [userDefaults setObject:self.keyword forKey:SEARCH_KEYWORD];
    [userDefaults setObject:self.location forKey:SEARCH_LOCATION];
    [userDefaults setObject:self.date forKey:SEARCH_DATE];
    [userDefaults setInteger:self.distance forKey:SEARCH_DISTANCE];
    
    [userDefaults synchronize];
}

@end
