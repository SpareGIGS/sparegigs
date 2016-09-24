//
//  MyServiceTableViewCell.h
//  SpareGIGs
//
//  Created by thanks on 9/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_MY_SERVICE_HEIGHT 34

@interface MyServiceTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblRadius;
@property(nonatomic, weak) IBOutlet UIButton *btnDetail;

@end
