//
//  ZXY_MyCaseChooseRoleCell.h
//  LawProjection
//
//  Created by 宇周 on 14/11/13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const MyCaseChooseRoleCellID ;
typedef void (^ ZXY_MyCaseChooseRoleBlock)(NSString *);
@interface ZXY_MyCaseChooseRoleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roleSeg;
@property (copy, nonatomic) ZXY_MyCaseChooseRoleBlock currentRole;
- (IBAction)selectRoleAction:(id)sender;

@end
