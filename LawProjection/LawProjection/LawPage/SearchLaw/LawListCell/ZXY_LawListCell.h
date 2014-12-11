//
//  ZXY_LawListCell.h
//  LawProjection
//
//  Created by 宇周 on 14/10/27.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const LawListCellID;
@protocol ZXY_LawListDelegate <NSObject>
- (void)selectCurrentLaw:(NSDictionary *)currentLaw;
@end
@interface ZXY_LawListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *keywordLbl;
@property (weak, nonatomic) IBOutlet UILabel *introduceLbl;
@property (weak, nonatomic) id<ZXY_LawListDelegate>delegate;
@property (assign)BOOL isUserSelect;
@property (strong,nonatomic) NSDictionary *currentLawyer;
@property (weak, nonatomic) IBOutlet UIButton *selectImage;
- (IBAction)selectImageAction:(id)sender;
@end
