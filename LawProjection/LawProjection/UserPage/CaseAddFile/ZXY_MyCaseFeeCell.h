//
//  ZXY_MyCaseFeeCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const MyCaseFeeCellID;
@interface ZXY_MyCaseFeeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *agencyCostLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UILabel *discountedLbl;
@property (weak, nonatomic) IBOutlet UILabel *tipsLbl;
@property (weak, nonatomic) IBOutlet UILabel *finalLbl;
@property (weak, nonatomic) IBOutlet UILabel *finalYuan;
@property (weak, nonatomic) IBOutlet UILabel *finalValueLbl;
@end
