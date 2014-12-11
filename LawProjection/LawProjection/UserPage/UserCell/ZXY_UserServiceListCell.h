//
//  ZXY_UserServiceListCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-18.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const UserServiceListCellID;
@interface ZXY_UserServiceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *needToLbl;
@property (weak, nonatomic) IBOutlet UILabel *realFinishLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastLbl;
@end
