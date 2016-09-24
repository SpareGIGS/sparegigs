//
//  HireProviderViewController.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "RoomInfo.h"
#import "HireInfo.h"

@interface HireProviderViewController :BaseViewController

@property (nonatomic, retain) RoomInfo *room;
@property (nonatomic, retain) HireInfo *hireInfo;

@end

