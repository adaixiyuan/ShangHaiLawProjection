//
//  ZXY_Coor_SubCell.m
//  LawProjection
//
//  Created by developer on 14-9-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_Coor_SubCell.h"
NSString *const cellIdentifierSub=@"ZXY_Coor_SubCellID";
@interface ZXY_Coor_SubCell()
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)submitAction:(id)sender;

@end

@implementation ZXY_Coor_SubCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(submitBuyInfoDelegate)])
    {
        [self.delegate submitBuyInfoDelegate];
    }
}
@end
