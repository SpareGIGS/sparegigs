//
//  MyAnnotation.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if (self != nil) {
        self.coordinate = coordinate;
    }
    
    return self;
}

@end
