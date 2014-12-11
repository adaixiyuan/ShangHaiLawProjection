//
//  LawCityEntity.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-15.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LawCityEntity : NSManagedObject

@property (nonatomic, retain) NSString * cityID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parent;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * createAt;
@property (nonatomic, retain) NSString * updateAt;
@property (nonatomic, retain) NSString * createBy;
@property (nonatomic, retain) NSString * updateBy;
@property (nonatomic, retain) NSNumber * valid;
@property (nonatomic, retain) NSNumber * invisible;
@property (nonatomic, retain) NSNumber * versionS;

@end
