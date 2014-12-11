//
//  ZXY_LetterVoiceTextCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/30.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LetterVoiceTextCell.h"
NSString *const LetterVoiceTextCellID = @"zxylettervoicetextcellid";
@implementation ZXY_LetterVoiceTextCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)voiceAction:(id)sender {
    if(self.currentBlock)
    {
        self.currentBlock();
    }
}
@end
