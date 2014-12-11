//
//  ZXY_LetterTextFCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const LetterTextFCellID;
@interface ZXY_LetterTextFCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextField *valueLbl;

@end
