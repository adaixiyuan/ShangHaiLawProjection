//
//  LCYInvoiceModel.h
//  LawProjection
//
//  Created by eagle on 14/11/4.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const customerTypeEnterprise;   /**< 企业：CT0001 */
FOUNDATION_EXPORT NSString *const customerTypePersonal;     /**< 个人：CT0002 */

@class LCYInvoiceInvoiceType;

@interface LCYInvoiceLocation : NSObject

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *icyID;

@end

@interface LCYInvoiceModel : NSObject

/**
 *  发票金额
 */
@property (copy, nonatomic) NSString *invoicePrice;

/**
 *  模版名称
 */
@property (copy, nonatomic) NSString *templateName;

/**
 *  开具类型（企业：CT0001，个人：CT0002）
 */
@property (copy, nonatomic) NSString *customerType;

/**
 *  发票类型（如：普通增值税发票）
 */
@property (strong, nonatomic) LCYInvoiceInvoiceType *invoiceType;

/**
 *  发票抬头
 */
@property (copy, nonatomic) NSString *invoiceTitle;

// 地区
@property (strong, nonatomic) LCYInvoiceLocation *province;
@property (strong, nonatomic) LCYInvoiceLocation *city;
@property (strong, nonatomic) LCYInvoiceLocation *town;

/**
 *  详细地址
 */
@property (copy, nonatomic) NSString *address;

/**
 *  邮政编码
 */
@property (copy, nonatomic) NSString *postCode;

/**
 *  收件人
 */
@property (copy, nonatomic) NSString *receiver;

/**
 *  是否保存为模版
 */
@property (nonatomic) BOOL saveAsTemplate;

@end

@interface LCYInvoiceInvoiceType : NSObject

@property (copy, nonatomic) NSString *typeName;

@property (copy, nonatomic) NSString *typeID;

@end

