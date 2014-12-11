//
//  ZXY_SingleServiceUpperCell.m
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_SingleServiceUpperCell.h"
NSString *const SingleServiceUpperCellID = @"zxysingleserviceuppercellid";
@interface ZXY_SingleServiceUpperCell()
{
    
    __weak IBOutlet UILabel *historyTitle;
    __weak IBOutlet UILabel *moreServiceLbl;
}
- (IBAction)aNewServiceAction:(id)sender;
@end
@implementation ZXY_SingleServiceUpperCell

- (void)awakeFromNib {
    // Initialization code
    historyTitle.textColor = NAVIBARCOLOR;
    moreServiceLbl.textColor = NAVIBARCOLOR;
    self.upperBtn.backgroundColor = NAVIBARCOLOR;
    self.upperBtn.layer.cornerRadius = 2;
    self.upperBtn.layer.masksToBounds = YES;
    [self initMoreServiceLbl];
}

- (void)initMoreServiceLbl
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreHistoryService)];
    moreServiceLbl.userInteractionEnabled = YES;
    [moreServiceLbl addGestureRecognizer:tap];
}

- (void)moreHistoryService
{
    if([self.delegate respondsToSelector:@selector(selectMoreHistoryBtn)])
    {
        [self.delegate selectMoreHistoryBtn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)aNewServiceAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(addANewService)])
    {
        [self.delegate addANewService];
    }
}
@end
