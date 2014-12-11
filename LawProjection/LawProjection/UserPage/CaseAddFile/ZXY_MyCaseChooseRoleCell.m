//
//  ZXY_MyCaseChooseRoleCell.m
//  LawProjection
//
//  Created by 宇周 on 14/11/13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_MyCaseChooseRoleCell.h"
NSString *const MyCaseChooseRoleCellID = @"zxymycasechooserolecellid";
@interface ZXY_MyCaseChooseRoleCell()
{
   
}
@end

@implementation ZXY_MyCaseChooseRoleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)selectRoleAction:(id)sender
{
    NSString *roleString;
    if(self.roleSeg.selectedSegmentIndex == 0)
    {
        roleString = @"1";
    }
    else
    {
        roleString = @"2";
    }
    if(self.currentRole)
    {
        self.currentRole(roleString);
    }
}
@end
