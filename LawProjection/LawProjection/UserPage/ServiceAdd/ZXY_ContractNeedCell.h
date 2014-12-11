//
//  ZXY_ContractNeedCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const ContractNeedCellID;
typedef  void (^ ZXY_ContractNeedCellBlock)();
@interface ZXY_ContractNeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *needTextV;
@property (weak, nonatomic) IBOutlet UIButton *speechBtn;
@property (nonatomic,copy) ZXY_ContractNeedCellBlock currentBlock;
- (IBAction)speechAction:(id)sender;
@end
