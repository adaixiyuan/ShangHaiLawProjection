//
//  LCYOrderDetailViewController.h
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYPhoneViewController.h"
#import "LCYOrderListModel.h"

@interface LCYOrderDetailViewController : LCYPhoneViewController

@property (strong, nonatomic) LCYOrderListModel *preOrderModel;

@end
