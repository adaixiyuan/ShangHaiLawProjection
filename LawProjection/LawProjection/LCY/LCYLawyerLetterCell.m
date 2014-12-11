//
//  LCYLawyerLetterCell.m
//  LawProjection
//
//  Created by eagle on 14/10/31.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYLawyerLetterCell.h"

NSString *const LCYLawyerLetterCellIdentifier = @"LCYLawyerLetterCellIdentifier";

@interface LCYLawyerLetterCell ()

@property (weak, nonatomic) IBOutlet UIView *icyIconBackView;

@property (weak, nonatomic) IBOutlet UILabel *icyIconLabel;

@end

@implementation LCYLawyerLetterCell

- (void)awakeFromNib {
    // Initialization code
    
    CGFloat radius = MIN(self.icyIconBackView.bounds.size.width, self.icyIconBackView.bounds.size.height) / 2.0f;
    [self.icyIconBackView.layer setCornerRadius:radius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIconStatus:(LCYLawyerLetterStatus)iconStatus {
    switch (iconStatus) {
        case LCYLawyerLetterStatusCommit:
            self.icyIconBackView.backgroundColor = [UIColor colorWithRed:0.0 green:205.0/255.0 blue:1.0 alpha:1.0];
            self.icyIconLabel.text = @"提交";
            break;
        case LCYLawyerLetterStatusDraft:
            self.icyIconBackView.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:166.0/255.0 blue:230.0/255.0 alpha:1.0];
            self.icyIconLabel.text = @"起草";
            break;
        case LCYLawyerLetterStatusConfirm:
            self.icyIconBackView.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:203.0/255.0 blue:160.0/255.0 alpha:1.0];
            self.icyIconLabel.text = @"确认";
            break;
        case LCYLawyerLetterStatusSend:
            self.icyIconBackView.backgroundColor = [UIColor colorWithRed:107.0/255.0 green:211.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.icyIconLabel.text = @"发送";
            break;
        case LCYLawyerLetterStatusSavefile:
            self.icyIconBackView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:88.0/255.0 alpha:1.0];
            self.icyIconLabel.text = @"存档";
            break;
        
        default:
            break;
    }
}

@end
