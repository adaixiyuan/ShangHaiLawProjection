//
//  ZXY_UserTabListBtnCell.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserTabListBtnCell.h"
NSString *const userTabListBtnCellID = @"zxyusertablistbtncellID";
@implementation ZXY_UserTabListBtnCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)getPhoneNumCheck:(id)sender
{
    if([self.delegate respondsToSelector:@selector(checkPhoneNum)])
    {
        [self.delegate checkPhoneNum];
    }
}
@end
