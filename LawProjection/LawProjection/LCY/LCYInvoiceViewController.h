//
//  LCYInvoiceViewController.h
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCYPhoneViewController.h"

@interface LCYInvoiceViewController : LCYPhoneViewController

@property (copy, nonatomic) NSString *orderID;

@property (copy, nonatomic) NSString *invoiceMoney;

@property (copy, nonatomic) NSArray *invoiceTemplates;

@property (copy, nonatomic) void (^doneBlock)(void);

- (void)setDetailInfo:(NSDictionary *)modernInfo;
@end
