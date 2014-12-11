//
//  LCYGetRatingBase.h
//
//  Created by 超逸 李 on 14/11/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCYGetRatingData;

@interface LCYGetRatingBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *apiVersion;
@property (nonatomic, strong) LCYGetRatingData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
