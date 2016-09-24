//
//  FavoriteTableViewCell.m
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import "FavoriteTableViewCell.h"

#import "DataManager.h"

@implementation FavoriteTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUserInfo:(UserInfo *)user
{
    [self.ivProfile displayImageFromURL:user.profile completionHandler:nil];
    self.lblUsername.text = user.username;
    [self showAddressFromLocation:user.location];
}

- (void) showAddressFromLocation:(NSString *)location
{
    if(location.length == 0) {
        self.lblLocation.text = @"None";
    } else {
        NSArray *positions = [location componentsSeparatedByString:@","];
        
        if(positions.count != 2) {
            self.lblLocation.text = @"None";
        } else {
            
            self.lblLocation.text = @"Loading...";
            
            double lat = [[positions objectAtIndex:0] doubleValue];
            double lng = [[positions objectAtIndex:1] doubleValue];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            [DataManager getAddressWithLocation:location label:self.lblLocation];
        }
    }
}

- (void) updateStars:(NSInteger)rating
{
    self.ivStar5.hidden = !(rating > 4);
    self.ivStar4.hidden = !(rating > 3);
    self.ivStar3.hidden = !(rating > 2);
    self.ivStar2.hidden = !(rating > 1);
    self.ivStar1.hidden = !(rating > 0);
}

@end
