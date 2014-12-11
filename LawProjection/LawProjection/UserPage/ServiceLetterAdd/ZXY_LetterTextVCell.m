//
//  ZXY_LetterTextVCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LetterTextVCell.h"
NSString *const LetterTextVCell = @"zxylettertextvcellid";
@implementation ZXY_LetterTextVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.contentTV.layer.cornerRadius = 4;
    self.contentTV.layer.masksToBounds= YES;
    self.contentTV.layer.borderColor  = [UIColor grayColor].CGColor;
    self.contentTV.layer.borderWidth  = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)voiceAction:(id)sender {
    if(self.btnBlock)
    {
        self.btnBlock();
    }
}
@end
