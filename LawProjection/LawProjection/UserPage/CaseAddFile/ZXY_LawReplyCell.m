//
//  ZXY_LawReplyCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LawReplyCell.h"
NSString *const LawReplyCellID = @"zxylawreplycellid";
@implementation ZXY_LawReplyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectLawAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(sendSelectLawID:)])
    {
        [self.delegate sendSelectLawID:self.lawyerID];
    }
}
@end
