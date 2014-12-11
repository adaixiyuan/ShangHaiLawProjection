//
//  ContractType.h
//  LawProjection
//
//  Created by 宇周 on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContractType : NSManagedObject

@property (nonatomic, retain) NSString * contractType;
@property (nonatomic, retain) NSString * typeID;
@property (nonatomic, retain) NSString * typeValue;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * parentID;

@end
