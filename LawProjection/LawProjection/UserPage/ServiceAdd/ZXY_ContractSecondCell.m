//
//  ZXY_ContractSecondCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_ContractSecondCell.h"
#import "ContractType.h"
NSString *const ContractSecondCell = @"zxycontractsecondcellid";
@implementation ZXY_ContractSecondCell

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
    NSInteger allCount = self.allContractType.count;
    [self.selectSeg removeAllSegments];
    for(int i = 0;i<allCount;i++)
    {
        ContractType *currentContract = [self.allContractType objectAtIndex:i];
        [self.selectSeg insertSegmentWithTitle:currentContract.typeName atIndex:i animated:NO];
    }
    [self.selectSeg setSelectedSegmentIndex:self.selectIndex];
}

- (IBAction)userSelectType:(id)sender
{
    NSInteger selectNum = [self.selectSeg selectedSegmentIndex];
    if(self.selectRoleBlock)
    {
        ContractType *selectContract = [self.allContractType objectAtIndex:selectNum];
        self.selectRoleBlock(selectContract);
    }
}

@end
