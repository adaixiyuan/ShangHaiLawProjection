//
//  ZXY_ContractFirstCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const ContractFirstCellID;
typedef void (^ ZXYQuestionBtnBlock)();
@interface ZXY_ContractFirstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *valueLbl;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
- (IBAction)questionAction:(id)sender;
@property (nonatomic,copy)ZXYQuestionBtnBlock lalaBlock;

@end
