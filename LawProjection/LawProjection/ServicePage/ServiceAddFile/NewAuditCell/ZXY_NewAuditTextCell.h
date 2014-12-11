//
//  ZXY_NewAuditTextCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const NewAuditTextCellID;
typedef void (^ ZXY_NewAuditTextCellBlock)();
@interface ZXY_NewAuditTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIView *backImageV;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (strong, nonatomic) ZXY_NewAuditTextCellBlock btnBlock;
- (IBAction)recordBtnAction:(id)sender;

@end
