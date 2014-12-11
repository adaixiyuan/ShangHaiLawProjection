//
//  LCYOrderDetailHeadCell.h
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYOrderDetailHeadCellIdentifier;

@interface LCYOrderDetailHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *icyIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyStartTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyProductLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyCostLabel;

@property (weak, nonatomic) IBOutlet UILabel *invoiceType;


@end
