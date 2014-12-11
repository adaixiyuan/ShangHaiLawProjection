//
//  LawCaseTypeEntity.m
//  LawProjection
//
//  Created by 宇周 on 14/10/28.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LawCaseTypeEntity.h"


@implementation LawCaseTypeEntity

@dynamic caseTypeID;
@dynamic name;
@dynamic sort;
@dynamic value;
@dynamic categoryId;
- (NSString *)description
{
    NSString *returnString = [NSString stringWithFormat:@" -->{name : %@\n caseType:%@\n sort:%@\n}",self.name,self.caseTypeID,self.sort];
    return returnString;
}
@end
