//
//  ZXY_LetterTextVCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/11.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const LetterTextVCell;
typedef  void (^ ZXY_LetterTextVCBlock)();
@interface ZXY_LetterTextVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
- (IBAction)voiceAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (copy, nonatomic) ZXY_LetterTextVCBlock btnBlock;
@end
