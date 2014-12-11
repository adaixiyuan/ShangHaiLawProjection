//
//  LCYOrderListCell.h
//  LawProjection
//
//  Created by eagle on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYOrderListCellIdentifier;

@interface LCYOrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *icyIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyStartTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyProductLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyCostLabel;

@end
