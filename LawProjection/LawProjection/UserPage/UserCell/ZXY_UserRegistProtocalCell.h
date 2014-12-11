//
//  ZXY_UserRegistProtocalCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-13.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const userRegistProtocalCellID;
@protocol ZXY_UserProtocalDelegate <NSObject>

- (void)userChooseProtocal;
- (void)userReviewProtocal;

@end

@interface ZXY_UserRegistProtocalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *regtancleImage;
@property (weak, nonatomic) IBOutlet UILabel *protocalForRead;
@property (weak, nonatomic) IBOutlet UILabel *protocalForClick;
@property (strong,nonatomic)id<ZXY_UserProtocalDelegate>delegate;

@end
