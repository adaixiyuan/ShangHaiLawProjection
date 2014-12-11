//
//  ZXY_ContractSubmitCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const ContractSubmitCellID;
typedef void (^ ZXY_CONtractSubmitBlock )(void);
@interface ZXY_ContractSubmitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic,strong) ZXY_CONtractSubmitBlock submitBlock;
@end
