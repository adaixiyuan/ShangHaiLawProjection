//
//  LCYOrderListModel.h
//  LawProjection
//
//  Created by eagle on 14/11/3.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LCYOrderListProductType) {
    LCYOrderListProductTypeBuy,         /**< 购买 */
    LCYOrderListProductTypeActivate,    /**< 激活法律卡 */
    LCYOrderListProductTypeDelegate,    /**< 案件委托 */
};

@interface LCYOrderListModel : NSObject

@property (copy, nonatomic) NSString *orderID;

@property (copy, nonatomic) NSString *commitTime;

@property (copy, nonatomic) NSString *status;

@property (copy, nonatomic) NSString *productString;

@property (copy, nonatomic) NSString *costMoney;

@property (nonatomic) LCYOrderListProductType type;

@property (copy, nonatomic) NSString *dbIdentifier;

@property (copy, nonatomic) NSString *lawyer;
@end
