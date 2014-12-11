//
//  ZXY_UserRegistProtocalCell.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserRegistProtocalCell.h"
NSString *const userRegistProtocalCellID=@"zxyuserregistprotocalcellID";
@interface ZXY_UserRegistProtocalCell()
{
    BOOL chooseIS;
}
@end

@implementation ZXY_UserRegistProtocalCell

- (void)awakeFromNib {
    // Initialization code
    self.regtancleImage.userInteractionEnabled  = YES;
    self.protocalForRead.userInteractionEnabled = YES;
    self.protocalForClick.userInteractionEnabled= YES;
    
    UITapGestureRecognizer *chooseProtocalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseProtocalTap:)];
    UITapGestureRecognizer *chooseProtocalTapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseProtocalTap:)];
    [self.regtancleImage addGestureRecognizer:chooseProtocalTapImage];
    [self.protocalForClick addGestureRecognizer:chooseProtocalTap];
    
    UITapGestureRecognizer *clickReviewTap   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviewProtocalTap:)];
    [self.protocalForRead addGestureRecognizer:clickReviewTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)chooseProtocalTap:(UITapGestureRecognizer *)tap
{
    if(!chooseIS)
    {
        chooseIS=YES;
        self.regtancleImage.image = [UIImage imageNamed:@"blueRegSelect"];
    }
    else
    {
        chooseIS=NO;
        self.regtancleImage.image = [UIImage imageNamed:@"blueReg"];
    }
    if([self.delegate respondsToSelector:@selector(userChooseProtocal)])
    {
        [self.delegate userChooseProtocal];
    }
}

- (void)reviewProtocalTap:(UITapGestureRecognizer *)tap
{
    if([self.delegate respondsToSelector:@selector(userReviewProtocal)])
    {
        [self.delegate userReviewProtocal];
    }
}
@end
