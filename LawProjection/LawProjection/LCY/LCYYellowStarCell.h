//
//  LCYYellowStarCell.h
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYYellowStarCellIdentifier;

@interface LCYYellowStarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *icyTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyContentLabel;

- (void)makeRating:(NSInteger)rating andFloat:(float)realValue;

@end
