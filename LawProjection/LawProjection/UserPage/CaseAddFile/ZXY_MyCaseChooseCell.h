//
//  ZXY_MyCaseChooseCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const MyCaseChooseCellID ;
@interface ZXY_MyCaseChooseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *valueLbl;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@end
