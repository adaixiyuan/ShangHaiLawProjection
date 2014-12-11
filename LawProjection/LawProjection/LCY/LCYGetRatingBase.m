//
//  LCYGetRatingBase.m
//
//  Created by 超逸 李 on 14/11/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetRatingBase.h"
#import "LCYGetRatingData.h"


NSString *const kLCYGetRatingBaseApiVersion = @"apiVersion";
NSString *const kLCYGetRatingBaseData = @"data";


@interface LCYGetRatingBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetRatingBase

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
            self.apiVersion = [self objectOrNilForKey:kLCYGetRatingBaseApiVersion fromDictionary:dict];
            self.data = [LCYGetRatingData modelObjectWithDictionary:[dict objectForKey:kLCYGetRatingBaseData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.apiVersion forKey:kLCYGetRatingBaseApiVersion];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kLCYGetRatingBaseData];

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

    self.apiVersion = [aDecoder decodeObjectForKey:kLCYGetRatingBaseApiVersion];
    self.data = [aDecoder decodeObjectForKey:kLCYGetRatingBaseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_apiVersion forKey:kLCYGetRatingBaseApiVersion];
    [aCoder encodeObject:_data forKey:kLCYGetRatingBaseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetRatingBase *copy = [[LCYGetRatingBase alloc] init];
    
    if (copy) {

        copy.apiVersion = [self.apiVersion copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
