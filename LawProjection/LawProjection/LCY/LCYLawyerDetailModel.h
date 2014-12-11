//
//  LCYLawyerDetailModel.h
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCYLawyerDetailModel : NSObject

@property (copy, nonatomic) NSString *portraitURL;

@property (copy, nonatomic) NSString *name;

@property (nonatomic) NSInteger attitudeRating;

@property (nonatomic) float attitudeFloat;

@property (nonatomic) NSInteger professionRating;
@property (nonatomic) float professionFloat;

@property (nonatomic) NSInteger responsibilityRating;
@property (nonatomic) float responsibilityFloat;

@property (nonatomic) BOOL copartner;

@property (copy, nonatomic) NSString *office;

@property (copy, nonatomic) NSString *province;

@property (copy, nonatomic) NSString *city;

@property (copy, nonatomic) NSString *town;

@property (nonatomic) NSInteger age;

@property (copy, nonatomic) NSString *careerStartTime;

/**
 *  擅长领域
 */
@property (copy, nonatomic) NSArray *expertFields;
@property (copy, nonatomic) NSString *expertString;

@property (copy, nonatomic) NSString *brief;

/**
 *  办案经验
 */
@property (copy, nonatomic) NSArray *experiences;

// 履历
@property (copy, nonatomic) NSArray *careerArray;

@end
