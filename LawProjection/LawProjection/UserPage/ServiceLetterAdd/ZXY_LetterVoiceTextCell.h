//
//  ZXY_LetterVoiceTextCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/30.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const LetterVoiceTextCellID;
typedef void (^ZXY_LetterVoiceBlock)() ;
@interface ZXY_LetterVoiceTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
- (IBAction)voiceAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *valueLbl;
@property (copy,nonatomic) ZXY_LetterVoiceBlock currentBlock;
@end
