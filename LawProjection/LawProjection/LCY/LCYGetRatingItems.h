//
//  LCYGetRatingItems.h
//
//  Created by 超逸 李 on 14/11/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCYGetRatingItems : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *itemsIdentifier;
@property (nonatomic, strong) NSString *lawyer;
@property (nonatomic, assign) double professional;
@property (nonatomic, assign) double attitude;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *caseProperty;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) double responsibility;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
