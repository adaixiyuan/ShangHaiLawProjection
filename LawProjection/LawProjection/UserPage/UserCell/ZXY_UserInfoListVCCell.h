//
//  ZXY_UserInfoListVCCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-19.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const UserInfoListVCCellID;
@interface ZXY_UserInfoListVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *valueLbl;

@end
