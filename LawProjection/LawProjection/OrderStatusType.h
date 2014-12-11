//
//  OrderStatusType.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-21.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderStatusType : NSManagedObject

@property (nonatomic, retain) NSString * statusID;
@property (nonatomic, retain) NSString * statusName;

@end
