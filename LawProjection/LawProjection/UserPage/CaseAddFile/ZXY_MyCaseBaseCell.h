//
//  ZXY_MyCaseBaseCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const MyCaseBaseCellID;
@interface ZXY_MyCaseBaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *valueLbl;

@end
