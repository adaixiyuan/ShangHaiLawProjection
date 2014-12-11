//
//  ZXY_NewAuditFileCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const NewAuditFileCellID;
@interface ZXY_NewAuditFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLbl;
@property (weak, nonatomic) IBOutlet UILabel *fileLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLblw;


@end
