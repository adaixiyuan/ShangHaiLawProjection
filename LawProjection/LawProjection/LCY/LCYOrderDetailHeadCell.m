//
//  LCYOrderDetailHeadCell.m
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYOrderDetailHeadCell.h"

NSString *const LCYOrderDetailHeadCellIdentifier = @"LCYOrderDetailHeadCellIdentifier";

@interface LCYOrderDetailHeadCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;

@end

@implementation LCYOrderDetailHeadCell

- (void)awakeFromNib {
    // Initialization code
    self.lineHeightConstraint.constant = 1.0f / [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
