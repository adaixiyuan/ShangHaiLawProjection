//
//  ZXY_MyCaseFileAttrCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const MyCaseFileAttrCellID;
@interface ZXY_MyCaseFileAttrCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@end
