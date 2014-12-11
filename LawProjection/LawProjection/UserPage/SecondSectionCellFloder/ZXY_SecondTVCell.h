//
//  ZXY_SecondTVCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const SecondTVCellID;
@interface ZXY_SecondTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstRowLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondRowLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (nonatomic,strong)NSString *currentStatus;
@end
