//
//  ZXY_ContractFirstCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ContractFirstCell.h"
NSString *const ContractFirstCellID=@"zxycontractfirstcellid";
@implementation ZXY_ContractFirstCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)questionAction:(id)sender {
    if(self.lalaBlock)
    {
        self.lalaBlock();
    }
}
@end
