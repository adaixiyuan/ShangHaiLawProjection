//
//  ZXY_UserLawTrainCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const UserLawTrainCellID;
@interface ZXY_UserLawTrainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *indexLbl;
@property (weak, nonatomic) IBOutlet UITextView *desText;
@end
