//
//  AddedServiceTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_ADDED_SERVICE_HEIGHT 40

@interface AddedServiceTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UIButton *btnRemove;

@end
