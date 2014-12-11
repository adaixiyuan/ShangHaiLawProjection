//
//  ZXY_MyCaseFeeForListCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/23.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const MyCaseFeeForListCellID;
@interface ZXY_MyCaseFeeForListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *feeType;
@property (weak, nonatomic) IBOutlet UILabel *feeIndex;
@property (weak, nonatomic) IBOutlet UILabel *feeTime;
@property (weak, nonatomic) IBOutlet UILabel *feeCost;
@property (weak, nonatomic) IBOutlet UILabel *feeLeft;

@end
