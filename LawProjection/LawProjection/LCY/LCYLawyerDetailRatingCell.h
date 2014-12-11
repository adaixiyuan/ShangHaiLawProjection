//
//  LCYLawyerDetailRatingCell.h
//  LawProjection
//
//  Created by eagle on 14/11/14.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYLawyerDetailRatingCellIdentifier;

@interface LCYLawyerDetailRatingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *icyTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyTopLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyMidLabel;

@property (weak, nonatomic) IBOutlet UILabel *icyBottomLabel;

@end
