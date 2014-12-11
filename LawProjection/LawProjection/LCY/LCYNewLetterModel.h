//
//  LCYNewLetterModel.h
//  LawProjection
//
//  Created by eagle on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LCYNewLetterType) {
    LCYNewLetterTypePersonal,
    LCYNewLetterTypeEnterprise,
};

@class LCYNewLetterLocation;

@interface LCYNewLetterModel : NSObject

/**
 *  类型
 */
@property (nonatomic) LCYNewLetterType type;

/**
 *  收件人
 */
@property (copy, nonatomic) NSString *receiverName;

/**
 *  联系电话
 */
@property (copy, nonatomic) NSString *telephone;

/**
 *  省份
 */
@property (strong, nonatomic) LCYNewLetterLocation *province;

/**
 *  城市
 */
@property (strong, nonatomic) LCYNewLetterLocation *city;

/**
 *  城区
 */
@property (strong, nonatomic) LCYNewLetterLocation *town;

/**
 *  详细地址
 */
@property (copy, nonatomic) NSString *address;

/**
 *  邮政编码
 */
@property (copy, nonatomic) NSString *postCode;

/**
 *  问题描述
 */
@property (copy, nonatomic) NSString *question;

/**
 *  期望
 */
@property (copy, nonatomic) NSString *expectation;

/**
 *  证据资料
 */
@property (copy, nonatomic) NSArray *evidence;

/**
 *  企业名称
 */
@property (copy, nonatomic) NSString *enterprise;

/**
 *  本次纪录的id（仅更新时有值）
 */
@property (copy, nonatomic) NSString *dbIdentifier;

@end

@interface LCYNewLetterEvidence : NSObject

@property (copy, nonatomic) NSString *fileName;

@property (copy, nonatomic) NSString *fileID;

@end

@interface LCYNewLetterLocation : NSObject

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *icyID;

@end
