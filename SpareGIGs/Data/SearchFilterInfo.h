//
//  SearchFilterInfo.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchFilterInfo : NSObject

@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *date;

@property (nonatomic, assign) NSInteger distance;

- (void) _init;
- (void) save;

@end
