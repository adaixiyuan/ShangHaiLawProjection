//
//  ZXY_UserOrderCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const UserOrderCellID;

@interface ZXY_UserOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLbl;

@end
