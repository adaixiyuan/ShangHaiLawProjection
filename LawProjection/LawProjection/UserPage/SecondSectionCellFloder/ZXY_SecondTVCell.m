//
//  ZXY_SecondTVCell.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_SecondTVCell.h"


NSString *const SecondTVCellID = @"zxysecondtvcellid";
@implementation ZXY_SecondTVCell

- (void)awakeFromNib {
    // Initialization code
    }

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    self.statusImage.layer.cornerRadius = 24;
//    self.statusImage.layer.masksToBounds = YES;
//    NSLog(@"%@",self.currentStatus);
//    if([self.currentStatus isEqualToString:@"LS0001"]||[self.currentStatus isEqualToString:@"AAS001"])
//    {
//        self.statusImage.backgroundColor = ONECOLOR;
//    }
//    else if ([self.currentStatus isEqualToString:@"LS0002"]|[self.currentStatus isEqualToString:@"AAS002"])
//    {
//        self.statusImage.backgroundColor = TWOCOLOR;
//    }
//    else if ([self.currentStatus isEqualToString:@"LS0003"]|[self.currentStatus isEqualToString:@"AAS003"])
//    {
//        self.statusImage.backgroundColor = THIRDCOLOR;
//    }
//    else if ([self.currentStatus isEqualToString:@"LS0004"]|[self.currentStatus isEqualToString:@"AAS004"])
//    {
//        self.statusImage.backgroundColor = FOURCOLOR;
//    }
//    else
//    {
//        self.statusImage.backgroundColor = FIVECOLOR;
//    }
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
