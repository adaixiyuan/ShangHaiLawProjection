//
//  LCYInvoiceSwitchCell.m
//  LawProjection
//
//  Created by eagle on 14/11/5.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYInvoiceSwitchCell.h"

NSString *const LCYInvoiceSwitchCellIdentifier = @"LCYInvoiceSwitchCellIdentifier";

@implementation LCYInvoiceSwitchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)icySwitchValueChanged:(UISwitch *)sender {
    if (self.switchValueChangeBlock) {
        self.switchValueChangeBlock(sender.isOn);
    }
}

@end
