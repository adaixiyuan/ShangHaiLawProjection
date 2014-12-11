//
//  ZXY_Coor_TabCell.h
//  LawProjection
//
//  Created by developer on 14-9-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const cellIdentifierTab;

@protocol TabDelegate <NSObject>
- (void)coorTabBarChanged:(BOOL)isNormal;
@end

@interface ZXY_Coor_TabCell : UITableViewCell
@property(nonatomic,strong)id<TabDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *specalBtn;
@end
