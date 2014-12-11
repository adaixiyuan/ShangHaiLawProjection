//
//  LCYOrderListDetailModel.h
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCYOrderListModel.h"

@interface LCYOrderListDetailModel : NSObject

@property (copy, nonatomic) NSString *dbIdentifier;

@property (copy, nonatomic) NSString *orderID;

@property (copy, nonatomic) NSString *commitTime;

@property (copy, nonatomic) NSString *status;

@property (copy, nonatomic) NSString *productString;

@property (copy, nonatomic) NSString *costMoney;

@property (nonatomic) LCYOrderListProductType type;



/**
 *  详情：产品名称
 */
@property (copy, nonatomic) NSString *productName;

/**
 *  详情：服务项目
 */
@property (copy, nonatomic) NSArray *serviceItems;

/**
 *  详情：购买数量
 */
@property (copy, nonatomic) NSString *buyNumberString;

/**
 *  详情：总金额
 */
@property (copy, nonatomic) NSString *totalCostMoney;

@end

@interface LCYOrderListDetailServiceItem : NSObject

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *countString;

@end
