//
//  ZXY_ContractSubmitCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ContractSubmitCell.h"
NSString *const ContractSubmitCellID = @"zxycontractsubmitcell";
@implementation ZXY_ContractSubmitCell

- (void)awakeFromNib {
    // Initialization code
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds= YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)begainSubmitAction:(id)sender {
    if(self.submitBlock)
    {
        self.submitBlock();
    }
}

@end
