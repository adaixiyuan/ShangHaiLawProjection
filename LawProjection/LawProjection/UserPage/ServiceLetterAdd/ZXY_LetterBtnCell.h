//
//  ZXY_LetterBtnCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const LetterBtnCellID;

@interface ZXY_LetterBtnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)submitAction:(id)sender;

@end
