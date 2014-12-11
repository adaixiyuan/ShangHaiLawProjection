//
//  LCYInvoiceDynamicCell.h
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const LCYInvoiceDynamicCellIdentifier;

@interface LCYInvoiceDynamicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *icyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *icyContentLabel;
@end
