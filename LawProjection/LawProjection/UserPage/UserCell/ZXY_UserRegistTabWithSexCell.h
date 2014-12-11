//
//  ZXY_UserRegistTabWithSexCell.h
//  LawProjection
//
//  Created by developer on 14-10-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const UserRegistTabWithSexCellID;
@protocol ZXY_UserRegistSexChooseDelegate <NSObject>

- (void)chooseSexWithID:(NSInteger)sexID;

@end

@interface ZXY_UserRegistTabWithSexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (nonatomic,strong)id<ZXY_UserRegistSexChooseDelegate>delegate;
@end
