//
//  LawCaseTypeEntity.h
//  LawProjection
//
//  Created by 宇周 on 14/10/28.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LawCaseTypeEntity : NSManagedObject

@property (nonatomic, retain) NSString * caseTypeID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sort;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * categoryId;
- (NSString *)description;
@end
