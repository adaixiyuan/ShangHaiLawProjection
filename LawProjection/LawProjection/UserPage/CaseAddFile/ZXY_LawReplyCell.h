//
//  ZXY_LawReplyCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const LawReplyCellID;
@protocol ZXY_LawReplyDelegate <NSObject>

- (void)sendSelectLawID:(NSString *)lawID;

@end
@interface ZXY_LawReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lawyerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *lawyerPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *modeLbl;
@property (weak, nonatomic) IBOutlet UILabel *feeLbl;
@property (weak, nonatomic) IBOutlet UILabel *ratioLbl;
//@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) NSString *lawyerID;
@property (weak, nonatomic) id<ZXY_LawReplyDelegate>delegate;
- (IBAction)selectLawAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cummentBtn;


@end
