//
//  ZXY_Coor_DataCell.h
//  LawProjection
//
//  Created by developer on 14-9-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const cellIdentifierData;
@interface ZXY_Coor_DataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_title;
@property (weak, nonatomic) IBOutlet UILabel *consultLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;

@end
