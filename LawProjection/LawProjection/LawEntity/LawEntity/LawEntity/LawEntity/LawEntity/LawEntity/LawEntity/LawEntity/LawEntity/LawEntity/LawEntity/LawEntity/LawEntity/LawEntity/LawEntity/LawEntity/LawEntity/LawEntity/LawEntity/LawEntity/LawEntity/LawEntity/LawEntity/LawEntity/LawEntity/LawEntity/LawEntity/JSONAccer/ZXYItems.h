//
//  ZXYItems.h
//
//  Created by   on 14/11/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZXYItems : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *itemsDescription;
@property (nonatomic, strong) NSString *createBy;
@property (nonatomic, assign) double valid;
@property (nonatomic, strong) NSString *updateBy;
@property (nonatomic, strong) NSString *translation;
@property (nonatomic, assign) id parent;
@property (nonatomic, strong) NSString *itemsIdentifier;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *updateAt;
@property (nonatomic, strong) NSString *visible;
@property (nonatomic, assign) double v;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *ancestors;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
