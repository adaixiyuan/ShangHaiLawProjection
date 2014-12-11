//
//  ZXY_NewAuditTextCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_NewAuditTextCell.h"
NSString *const NewAuditTextCellID = @"zxynewaudittextcellid";
@implementation ZXY_NewAuditTextCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.contentText.layer.cornerRadius = 4;
    self.contentText.layer.borderColor  = [UIColor grayColor].CGColor;
    self.contentText.layer.borderWidth  = 1;
    self.contentText.layer.masksToBounds= YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)recordBtnAction:(id)sender {
    if(self.btnBlock)
    {
        self.btnBlock();
    }
}
@end
