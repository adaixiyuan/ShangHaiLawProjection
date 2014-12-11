//
//  ZXY_UserLawConsultCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const UserLawConsultCellID;
@interface ZXY_UserLawConsultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;
@property (weak, nonatomic) IBOutlet UILabel *unitLbl;

@end
