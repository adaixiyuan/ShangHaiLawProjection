//
//  ZXYData.m
//
//  Created by   on 14/11/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ZXYData.h"
#import "ZXYItems.h"


NSString *const kZXYDataItems = @"items";
NSString *const kZXYDataTotalItems = @"totalItems";


@interface ZXYData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ZXYData

@synthesize items = _items;
@synthesize totalItems = _totalItems;


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
    NSObject *receivedZXYItems = [dict objectForKey:kZXYDataItems];
    NSMutableArray *parsedZXYItems = [NSMutableArray array];
    if ([receivedZXYItems isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedZXYItems) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedZXYItems addObject:[ZXYItems modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedZXYItems isKindOfClass:[NSDictionary class]]) {
       [parsedZXYItems addObject:[ZXYItems modelObjectWithDictionary:(NSDictionary *)receivedZXYItems]];
    }

    self.items = [NSArray arrayWithArray:parsedZXYItems];
            self.totalItems = [[self objectOrNilForKey:kZXYDataTotalItems fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForItems = [NSMutableArray array];
    for (NSObject *subArrayObject in self.items) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForItems addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForItems addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItems] forKey:kZXYDataItems];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalItems] forKey:kZXYDataTotalItems];

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

    self.items = [aDecoder decodeObjectForKey:kZXYDataItems];
    self.totalItems = [aDecoder decodeDoubleForKey:kZXYDataTotalItems];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_items forKey:kZXYDataItems];
    [aCoder encodeDouble:_totalItems forKey:kZXYDataTotalItems];
}

- (id)copyWithZone:(NSZone *)zone
{
    ZXYData *copy = [[ZXYData alloc] init];
    
    if (copy) {

        copy.items = [self.items copyWithZone:zone];
        copy.totalItems = self.totalItems;
    }
    
    return copy;
}


@end
