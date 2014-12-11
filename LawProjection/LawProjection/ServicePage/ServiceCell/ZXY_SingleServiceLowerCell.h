//
//  ZXY_SingleServiceLowerCell.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString *const SingleServiceLowerCellID;

@protocol ZXY_SingleServiceLowerDelegate <NSObject>

- (void)buyServiceWithNum:(NSInteger)num;

@end

@interface ZXY_SingleServiceLowerCell : UITableViewCell

@property (strong,nonatomic) NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UIButton *subtractionBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *singlePrice;
@property (weak, nonatomic) IBOutlet UILabel *sumPrice;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak,nonatomic)id<ZXY_SingleServiceLowerDelegate>delegate;

- (IBAction)buyAction:(id)sender;
@end
