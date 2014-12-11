//
//  ZXYContractType.h
//
//  Created by   on 14/11/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZXYData;

@interface ZXYContractType : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *apiVersion;
@property (nonatomic, strong) ZXYData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
