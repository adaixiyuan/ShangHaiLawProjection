//
//  LCYGetRatingData.m
//
//  Created by 超逸 李 on 14/11/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetRatingData.h"
#import "LCYGetRatingItems.h"


NSString *const kLCYGetRatingDataItems = @"items";


@interface LCYGetRatingData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetRatingData

@synthesize items = _items;


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
    NSObject *receivedLCYGetRatingItems = [dict objectForKey:kLCYGetRatingDataItems];
    NSMutableArray *parsedLCYGetRatingItems = [NSMutableArray array];
    if ([receivedLCYGetRatingItems isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLCYGetRatingItems) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLCYGetRatingItems addObject:[LCYGetRatingItems modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLCYGetRatingItems isKindOfClass:[NSDictionary class]]) {
       [parsedLCYGetRatingItems addObject:[LCYGetRatingItems modelObjectWithDictionary:(NSDictionary *)receivedLCYGetRatingItems]];
    }

    self.items = [NSArray arrayWithArray:parsedLCYGetRatingItems];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItems] forKey:kLCYGetRatingDataItems];

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

    self.items = [aDecoder decodeObjectForKey:kLCYGetRatingDataItems];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_items forKey:kLCYGetRatingDataItems];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetRatingData *copy = [[LCYGetRatingData alloc] init];
    
    if (copy) {

        copy.items = [self.items copyWithZone:zone];
    }
    
    return copy;
}


@end
