//
//  ZXY_Coor_SubCell.h
//  LawProjection
//
//  Created by developer on 14-9-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const cellIdentifierSub;

@protocol SubCellDelegate <NSObject>

- (void)submitBuyInfoDelegate;

@end
@interface ZXY_Coor_SubCell : UITableViewCell
@property (nonatomic,strong)id<SubCellDelegate>delegate;
@end
