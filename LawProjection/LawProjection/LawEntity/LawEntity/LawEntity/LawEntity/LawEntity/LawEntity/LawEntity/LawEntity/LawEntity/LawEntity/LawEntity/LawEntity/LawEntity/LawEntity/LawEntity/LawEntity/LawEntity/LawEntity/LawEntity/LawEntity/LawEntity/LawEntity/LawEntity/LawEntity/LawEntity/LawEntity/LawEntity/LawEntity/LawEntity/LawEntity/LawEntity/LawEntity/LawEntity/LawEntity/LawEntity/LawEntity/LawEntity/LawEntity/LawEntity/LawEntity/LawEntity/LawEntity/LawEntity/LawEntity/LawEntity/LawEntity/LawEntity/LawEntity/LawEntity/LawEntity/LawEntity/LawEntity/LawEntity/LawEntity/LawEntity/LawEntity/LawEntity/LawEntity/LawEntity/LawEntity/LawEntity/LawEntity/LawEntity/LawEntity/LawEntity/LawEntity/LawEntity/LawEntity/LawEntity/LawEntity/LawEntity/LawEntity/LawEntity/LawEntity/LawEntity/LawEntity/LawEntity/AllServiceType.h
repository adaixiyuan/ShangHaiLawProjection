//
//  AllServiceType.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-20.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AllServiceType : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * typeID;

@end
