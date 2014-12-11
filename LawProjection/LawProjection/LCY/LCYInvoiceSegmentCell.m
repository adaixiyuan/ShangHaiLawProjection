//
//  LCYInvoiceSegmentCell.m
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYInvoiceSegmentCell.h"

NSString *const LCYInvoiceSegmentCellIdentifier = @"LCYInvoiceSegmentCellIdentifier";

@implementation LCYInvoiceSegmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    if (self.segmentChanged) {
        self.segmentChanged(sender.selectedSegmentIndex);
    }
}
@end
