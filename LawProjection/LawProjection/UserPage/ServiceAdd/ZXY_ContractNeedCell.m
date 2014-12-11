//
//  ZXY_ContractNeedCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ContractNeedCell.h"
NSString *const ContractNeedCellID = @"zxycontractneedcellid";
@implementation ZXY_ContractNeedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.needTextV.layer.cornerRadius = 4;
    self.needTextV.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    self.needTextV.layer.borderWidth  = 1;
    self.needTextV.layer.masksToBounds= YES;
}

- (IBAction)speechAction:(id)sender {
    if(self.currentBlock)
    {
        self.currentBlock();
    }
}
@end
