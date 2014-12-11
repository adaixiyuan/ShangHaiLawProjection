//
//  ZXY_UserTabListBtnCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const userTabListBtnCellID;
@protocol ZXY_UserCheckNumDelegate <NSObject>

- (void)checkPhoneNum;

@end
@interface ZXY_UserTabListBtnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (strong,nonatomic) id<ZXY_UserCheckNumDelegate>delegate;

@end
