//
//  LawEntityHelper.h
//  LawProjection
//
//  Created by developer on 14-10-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LawEntityHelper : NSObject
+ (BOOL)saveUserInfo:(NSDictionary*)userInfo;
+ (BOOL)saveUserServiceInfo:(NSArray *)serviceInfo;
+ (BOOL)saveCaseType:(NSArray *)caseArr;
+ (BOOL)saveContractType:(NSArray *)contractArr;
@end
