//
//  ZXY_MyCaseTextCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_MyCaseTextCell.h"
NSString *const MyCaseTextCellID = @"zxymycasetextcellid";
@implementation ZXY_MyCaseTextCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.valueLbl.layer.cornerRadius = 4;
    self.valueLbl.layer.masksToBounds = YES;
    self.valueLbl.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.valueLbl.layer.borderWidth   = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
