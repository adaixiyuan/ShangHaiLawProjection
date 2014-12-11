//
//  ZXY_LawListCell.m
//  LawProjection
//
//  Created by 宇周 on 14/10/27.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_LawListCell.h"
NSString *const LawListCellID = @"zxylawlistcellid";

@implementation ZXY_LawListCell

- (void)awakeFromNib {
    // Initialization code
    
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    if(self.isUserSelect)
//    {
//        self.selectImage.image = [UIImage imageNamed:@"chooseLawer_select"];
//    }
//    else
//    {
//        self.selectImage.image = [UIImage imageNamed:@"chooseLawer"];
//    }
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)sendThisChooseBlock
{
    if([self.delegate respondsToSelector:@selector(selectCurrentLaw:)])
    {
        [self.delegate selectCurrentLaw:self.currentLawyer];
    }
}
- (IBAction)selectImageAction:(id)sender {
    [self sendThisChooseBlock];
}
@end
