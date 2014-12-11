//
//  ZXY_SingleServiceUpperCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const SingleServiceUpperCellID;
@protocol ZXY_SingleLawDelegate <NSObject>

- (void) selectMoreHistoryBtn;
- (void) addANewService;

@end

@interface ZXY_SingleServiceUpperCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstHistoryRowLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondHistoryRowLbl;
@property (weak, nonatomic) IBOutlet UIButton *upperBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailInfoLbl;
@property (nonatomic,weak) id<ZXY_SingleLawDelegate>delegate;

@end
