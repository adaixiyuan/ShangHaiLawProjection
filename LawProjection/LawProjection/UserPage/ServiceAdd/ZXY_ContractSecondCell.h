//
//  ZXY_ContractSecondCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContractType;
FOUNDATION_EXPORT NSString *const ContractSecondCell;
typedef void (^ ZXY_ContractSecondBlock)(ContractType *resultContractype);
@interface ZXY_ContractSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectSeg;
@property (strong,nonatomic) NSArray *allContractType;
@property (strong,nonatomic)ZXY_ContractSecondBlock selectRoleBlock;
@property (assign)NSInteger selectIndex;
@end
