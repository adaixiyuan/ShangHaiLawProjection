//
//  LCYGetRatingItems.m
//
//  Created by 超逸 李 on 14/11/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LCYGetRatingItems.h"


NSString *const kLCYGetRatingItemsId = @"_id";
NSString *const kLCYGetRatingItemsLawyer = @"lawyer";
NSString *const kLCYGetRatingItemsProfessional = @"professional";
NSString *const kLCYGetRatingItemsAttitude = @"attitude";
NSString *const kLCYGetRatingItemsCreateAt = @"createAt";
NSString *const kLCYGetRatingItemsCase = @"case";
NSString *const kLCYGetRatingItemsComment = @"comment";
NSString *const kLCYGetRatingItemsResponsibility = @"responsibility";


@interface LCYGetRatingItems ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LCYGetRatingItems

@synthesize itemsIdentifier = _itemsIdentifier;
@synthesize lawyer = _lawyer;
@synthesize professional = _professional;
@synthesize attitude = _attitude;
@synthesize createAt = _createAt;
@synthesize caseProperty = _caseProperty;
@synthesize comment = _comment;
@synthesize responsibility = _responsibility;


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
            self.itemsIdentifier = [self objectOrNilForKey:kLCYGetRatingItemsId fromDictionary:dict];
            self.lawyer = [self objectOrNilForKey:kLCYGetRatingItemsLawyer fromDictionary:dict];
            self.professional = [[self objectOrNilForKey:kLCYGetRatingItemsProfessional fromDictionary:dict] doubleValue];
            self.attitude = [[self objectOrNilForKey:kLCYGetRatingItemsAttitude fromDictionary:dict] doubleValue];
            self.createAt = [self objectOrNilForKey:kLCYGetRatingItemsCreateAt fromDictionary:dict];
            self.caseProperty = [self objectOrNilForKey:kLCYGetRatingItemsCase fromDictionary:dict];
            self.comment = [self objectOrNilForKey:kLCYGetRatingItemsComment fromDictionary:dict];
            self.responsibility = [[self objectOrNilForKey:kLCYGetRatingItemsResponsibility fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.itemsIdentifier forKey:kLCYGetRatingItemsId];
    [mutableDict setValue:self.lawyer forKey:kLCYGetRatingItemsLawyer];
    [mutableDict setValue:[NSNumber numberWithDouble:self.professional] forKey:kLCYGetRatingItemsProfessional];
    [mutableDict setValue:[NSNumber numberWithDouble:self.attitude] forKey:kLCYGetRatingItemsAttitude];
    [mutableDict setValue:self.createAt forKey:kLCYGetRatingItemsCreateAt];
    [mutableDict setValue:self.caseProperty forKey:kLCYGetRatingItemsCase];
    [mutableDict setValue:self.comment forKey:kLCYGetRatingItemsComment];
    [mutableDict setValue:[NSNumber numberWithDouble:self.responsibility] forKey:kLCYGetRatingItemsResponsibility];

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

    self.itemsIdentifier = [aDecoder decodeObjectForKey:kLCYGetRatingItemsId];
    self.lawyer = [aDecoder decodeObjectForKey:kLCYGetRatingItemsLawyer];
    self.professional = [aDecoder decodeDoubleForKey:kLCYGetRatingItemsProfessional];
    self.attitude = [aDecoder decodeDoubleForKey:kLCYGetRatingItemsAttitude];
    self.createAt = [aDecoder decodeObjectForKey:kLCYGetRatingItemsCreateAt];
    self.caseProperty = [aDecoder decodeObjectForKey:kLCYGetRatingItemsCase];
    self.comment = [aDecoder decodeObjectForKey:kLCYGetRatingItemsComment];
    self.responsibility = [aDecoder decodeDoubleForKey:kLCYGetRatingItemsResponsibility];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_itemsIdentifier forKey:kLCYGetRatingItemsId];
    [aCoder encodeObject:_lawyer forKey:kLCYGetRatingItemsLawyer];
    [aCoder encodeDouble:_professional forKey:kLCYGetRatingItemsProfessional];
    [aCoder encodeDouble:_attitude forKey:kLCYGetRatingItemsAttitude];
    [aCoder encodeObject:_createAt forKey:kLCYGetRatingItemsCreateAt];
    [aCoder encodeObject:_caseProperty forKey:kLCYGetRatingItemsCase];
    [aCoder encodeObject:_comment forKey:kLCYGetRatingItemsComment];
    [aCoder encodeDouble:_responsibility forKey:kLCYGetRatingItemsResponsibility];
}

- (id)copyWithZone:(NSZone *)zone
{
    LCYGetRatingItems *copy = [[LCYGetRatingItems alloc] init];
    
    if (copy) {

        copy.itemsIdentifier = [self.itemsIdentifier copyWithZone:zone];
        copy.lawyer = [self.lawyer copyWithZone:zone];
        copy.professional = self.professional;
        copy.attitude = self.attitude;
        copy.createAt = [self.createAt copyWithZone:zone];
        copy.caseProperty = [self.caseProperty copyWithZone:zone];
        copy.comment = [self.comment copyWithZone:zone];
        copy.responsibility = self.responsibility;
    }
    
    return copy;
}


@end
