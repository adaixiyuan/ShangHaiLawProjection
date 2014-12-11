//
//  ZXYContractType.m
//
//  Created by   on 14/11/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ZXYContractType.h"
#import "ZXYData.h"


NSString *const kZXYContractTypeApiVersion = @"apiVersion";
NSString *const kZXYContractTypeData = @"data";


@interface ZXYContractType ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ZXYContractType

@synthesize apiVersion = _apiVersion;
@synthesize data = _data;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.apiVersion = [self objectOrNilForKey:kZXYContractTypeApiVersion fromDictionary:dict];
            self.data = [ZXYData modelObjectWithDictionary:[dict objectForKey:kZXYContractTypeData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.apiVersion forKey:kZXYContractTypeApiVersion];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kZXYContractTypeData];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.apiVersion = [aDecoder decodeObjectForKey:kZXYContractTypeApiVersion];
    self.data = [aDecoder decodeObjectForKey:kZXYContractTypeData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_apiVersion forKey:kZXYContractTypeApiVersion];
    [aCoder encodeObject:_data forKey:kZXYContractTypeData];
}

- (id)copyWithZone:(NSZone *)zone
{
    ZXYContractType *copy = [[ZXYContractType alloc] init];
    
    if (copy) {

        copy.apiVersion = [self.apiVersion copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
