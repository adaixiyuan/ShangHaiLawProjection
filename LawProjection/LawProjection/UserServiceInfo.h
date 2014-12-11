//
//  UserServiceInfo.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllServiceType;

@interface UserServiceInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * usingAmounttotal;
@property (nonatomic, retain) NSString * serviceTypeName;
@property (nonatomic, retain) NSNumber * remainAmounttotal;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * serviceType;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSNumber * usedAmounttotal;
@property (nonatomic, retain) AllServiceType *toAllServiceType;

@end
