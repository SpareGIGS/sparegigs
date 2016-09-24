//
//  RoomTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_ROOM_HEIGHT 80

@interface RoomTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *ivProfile;

@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblType;
@property(nonatomic, weak) IBOutlet UILabel *lblServiceName;

@property(nonatomic, weak) IBOutlet UIView *viewMain;

@end
