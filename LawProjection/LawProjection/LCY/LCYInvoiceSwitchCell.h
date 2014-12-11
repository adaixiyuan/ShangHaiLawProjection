//
//  LCYInvoiceSwitchCell.h
//  LawProjection
//
//  Created by eagle on 14/11/5.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYInvoiceSwitchCellIdentifier;

@interface LCYInvoiceSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *icyTitleLabel;

@property (weak, nonatomic) IBOutlet UISwitch *icySwitch;

@property (copy, nonatomic) void (^switchValueChangeBlock)(BOOL state);

@end
