//
//  LCYCommon.h
//  LawProjection
//
//  Created by eagle on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

@interface LCYCommon : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYCommon*)sharedInstance;

- (NSDate *)convertDate:(NSString *)dateString;

@end
