//
//  ZXY_UserRegistTabWithSexCell.m
//  LawProjection
//
//  Created by developer on 14-10-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_UserRegistTabWithSexCell.h"
NSString *const UserRegistTabWithSexCellID=@"zxyuserregisttabwithsexcell";
@interface ZXY_UserRegistTabWithSexCell()
{
    
    __weak IBOutlet UISegmentedControl *sexChooseSeg;
}

@end

@implementation ZXY_UserRegistTabWithSexCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ds:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    NSInteger currentChoose = seg.selectedSegmentIndex;
    if([self.delegate respondsToSelector:@selector(chooseSexWithID:)])
    {
        [self.delegate chooseSexWithID:currentChoose];
    }
}

@end
