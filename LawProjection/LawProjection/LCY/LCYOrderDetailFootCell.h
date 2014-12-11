//
//  LCYOrderDetailFootCell.h
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYOrderDetailFootCellIdentifer;

@interface LCYOrderDetailFootCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;


@end
