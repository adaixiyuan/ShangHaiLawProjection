//
//  Items.h
//
//  Created by Mac  on 14-10-22
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Items : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *itemsDescription;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *updateBy;
@property (nonatomic, assign) double valid;
@property (nonatomic, strong) NSString *fileId;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *itemsIdentifier;
@property (nonatomic, assign) double length;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *updateAt;
@property (nonatomic, assign) double v;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *createBy;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
