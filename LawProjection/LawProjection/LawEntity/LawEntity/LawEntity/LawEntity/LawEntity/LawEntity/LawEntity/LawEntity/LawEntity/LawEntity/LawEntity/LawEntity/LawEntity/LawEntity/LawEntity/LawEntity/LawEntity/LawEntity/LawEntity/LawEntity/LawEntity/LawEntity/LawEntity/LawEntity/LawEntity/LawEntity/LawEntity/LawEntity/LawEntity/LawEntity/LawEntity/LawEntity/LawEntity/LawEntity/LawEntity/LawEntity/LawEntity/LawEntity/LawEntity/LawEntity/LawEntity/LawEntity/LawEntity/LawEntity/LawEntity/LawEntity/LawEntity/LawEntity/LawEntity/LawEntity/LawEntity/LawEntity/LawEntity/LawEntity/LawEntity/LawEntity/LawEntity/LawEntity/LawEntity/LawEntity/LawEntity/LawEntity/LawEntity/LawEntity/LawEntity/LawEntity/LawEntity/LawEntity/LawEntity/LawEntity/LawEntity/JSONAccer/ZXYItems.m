//
//  ZXYItems.m
//
//  Created by   on 14/11/1
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ZXYItems.h"


NSString *const kZXYItemsCategoryId = @"categoryId";
NSString *const kZXYItemsDescription = @"description";
NSString *const kZXYItemsCreateBy = @"createBy";
NSString *const kZXYItemsValid = @"valid";
NSString *const kZXYItemsUpdateBy = @"updateBy";
NSString *const kZXYItemsTranslation = @"translation";
NSString *const kZXYItemsParent = @"parent";
NSString *const kZXYItemsId = @"_id";
NSString *const kZXYItemsCreateAt = @"createAt";
NSString *const kZXYItemsType = @"type";
NSString *const kZXYItemsValue = @"value";
NSString *const kZXYItemsUpdateAt = @"updateAt";
NSString *const kZXYItemsVisible = @"visible";
NSString *const kZXYItemsV = @"__v";
NSString *const kZXYItemsSort = @"sort";
NSString *const kZXYItemsName = @"name";
NSString *const kZXYItemsAncestors = @"ancestors";


@interface ZXYItems ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ZXYItems

@synthesize categoryId = _categoryId;
@synthesize itemsDescription = _itemsDescription;
@synthesize createBy = _createBy;
@synthesize valid = _valid;
@synthesize updateBy = _updateBy;
@synthesize translation = _translation;
@synthesize parent = _parent;
@synthesize itemsIdentifier = _itemsIdentifier;
@synthesize createAt = _createAt;
@synthesize type = _type;
@synthesize value = _value;
@synthesize updateAt = _updateAt;
@synthesize visible = _visible;
@synthesize v = _v;
@synthesize sort = _sort;
@synthesize name = _name;
@synthesize ancestors = _ancestors;


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
            self.categoryId = [self objectOrNilForKey:kZXYItemsCategoryId fromDictionary:dict];
            self.itemsDescription = [self objectOrNilForKey:kZXYItemsDescription fromDictionary:dict];
            self.createBy = [self objectOrNilForKey:kZXYItemsCreateBy fromDictionary:dict];
            self.valid = [[self objectOrNilForKey:kZXYItemsValid fromDictionary:dict] doubleValue];
            self.updateBy = [self objectOrNilForKey:kZXYItemsUpdateBy fromDictionary:dict];
            self.translation = [self objectOrNilForKey:kZXYItemsTranslation fromDictionary:dict];
            self.parent = [self objectOrNilForKey:kZXYItemsParent fromDictionary:dict];
            self.itemsIdentifier = [self objectOrNilForKey:kZXYItemsId fromDictionary:dict];
            self.createAt = [self objectOrNilForKey:kZXYItemsCreateAt fromDictionary:dict];
            self.type = [self objectOrNilForKey:kZXYItemsType fromDictionary:dict];
            self.value = [self objectOrNilForKey:kZXYItemsValue fromDictionary:dict];
            self.updateAt = [self objectOrNilForKey:kZXYItemsUpdateAt fromDictionary:dict];
            self.visible = [self objectOrNilForKey:kZXYItemsVisible fromDictionary:dict];
            self.v = [[self objectOrNilForKey:kZXYItemsV fromDictionary:dict] doubleValue];
            self.sort = [self objectOrNilForKey:kZXYItemsSort fromDictionary:dict];
            self.name = [self objectOrNilForKey:kZXYItemsName fromDictionary:dict];
            self.ancestors = [self objectOrNilForKey:kZXYItemsAncestors fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.categoryId forKey:kZXYItemsCategoryId];
    [mutableDict setValue:self.itemsDescription forKey:kZXYItemsDescription];
    [mutableDict setValue:self.createBy forKey:kZXYItemsCreateBy];
    [mutableDict setValue:[NSNumber numberWithDouble:self.valid] forKey:kZXYItemsValid];
    [mutableDict setValue:self.updateBy forKey:kZXYItemsUpdateBy];
    [mutableDict setValue:self.translation forKey:kZXYItemsTranslation];
    [mutableDict setValue:self.parent forKey:kZXYItemsParent];
    [mutableDict setValue:self.itemsIdentifier forKey:kZXYItemsId];
    [mutableDict setValue:self.createAt forKey:kZXYItemsCreateAt];
    [mutableDict setValue:self.type forKey:kZXYItemsType];
    [mutableDict setValue:self.value forKey:kZXYItemsValue];
    [mutableDict setValue:self.updateAt forKey:kZXYItemsUpdateAt];
    [mutableDict setValue:self.visible forKey:kZXYItemsVisible];
    [mutableDict setValue:[NSNumber numberWithDouble:self.v] forKey:kZXYItemsV];
    [mutableDict setValue:self.sort forKey:kZXYItemsSort];
    [mutableDict setValue:self.name forKey:kZXYItemsName];
    NSMutableArray *tempArrayForAncestors = [NSMutableArray array];
    for (NSObject *subArrayObject in self.ancestors) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAncestors addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAncestors addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAncestors] forKey:kZXYItemsAncestors];

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

    self.categoryId = [aDecoder decodeObjectForKey:kZXYItemsCategoryId];
    self.itemsDescription = [aDecoder decodeObjectForKey:kZXYItemsDescription];
    self.createBy = [aDecoder decodeObjectForKey:kZXYItemsCreateBy];
    self.valid = [aDecoder decodeDoubleForKey:kZXYItemsValid];
    self.updateBy = [aDecoder decodeObjectForKey:kZXYItemsUpdateBy];
    self.translation = [aDecoder decodeObjectForKey:kZXYItemsTranslation];
    self.parent = [aDecoder decodeObjectForKey:kZXYItemsParent];
    self.itemsIdentifier = [aDecoder decodeObjectForKey:kZXYItemsId];
    self.createAt = [aDecoder decodeObjectForKey:kZXYItemsCreateAt];
    self.type = [aDecoder decodeObjectForKey:kZXYItemsType];
    self.value = [aDecoder decodeObjectForKey:kZXYItemsValue];
    self.updateAt = [aDecoder decodeObjectForKey:kZXYItemsUpdateAt];
    self.visible = [aDecoder decodeObjectForKey:kZXYItemsVisible];
    self.v = [aDecoder decodeDoubleForKey:kZXYItemsV];
    self.sort = [aDecoder decodeObjectForKey:kZXYItemsSort];
    self.name = [aDecoder decodeObjectForKey:kZXYItemsName];
    self.ancestors = [aDecoder decodeObjectForKey:kZXYItemsAncestors];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_categoryId forKey:kZXYItemsCategoryId];
    [aCoder encodeObject:_itemsDescription forKey:kZXYItemsDescription];
    [aCoder encodeObject:_createBy forKey:kZXYItemsCreateBy];
    [aCoder encodeDouble:_valid forKey:kZXYItemsValid];
    [aCoder encodeObject:_updateBy forKey:kZXYItemsUpdateBy];
    [aCoder encodeObject:_translation forKey:kZXYItemsTranslation];
    [aCoder encodeObject:_parent forKey:kZXYItemsParent];
    [aCoder encodeObject:_itemsIdentifier forKey:kZXYItemsId];
    [aCoder encodeObject:_createAt forKey:kZXYItemsCreateAt];
    [aCoder encodeObject:_type forKey:kZXYItemsType];
    [aCoder encodeObject:_value forKey:kZXYItemsValue];
    [aCoder encodeObject:_updateAt forKey:kZXYItemsUpdateAt];
    [aCoder encodeObject:_visible forKey:kZXYItemsVisible];
    [aCoder encodeDouble:_v forKey:kZXYItemsV];
    [aCoder encodeObject:_sort forKey:kZXYItemsSort];
    [aCoder encodeObject:_name forKey:kZXYItemsName];
    [aCoder encodeObject:_ancestors forKey:kZXYItemsAncestors];
}

- (id)copyWithZone:(NSZone *)zone
{
    ZXYItems *copy = [[ZXYItems alloc] init];
    
    if (copy) {

        copy.categoryId = [self.categoryId copyWithZone:zone];
        copy.itemsDescription = [self.itemsDescription copyWithZone:zone];
        copy.createBy = [self.createBy copyWithZone:zone];
        copy.valid = self.valid;
        copy.updateBy = [self.updateBy copyWithZone:zone];
        copy.translation = [self.translation copyWithZone:zone];
        copy.parent = [self.parent copyWithZone:zone];
        copy.itemsIdentifier = [self.itemsIdentifier copyWithZone:zone];
        copy.createAt = [self.createAt copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.value = [self.value copyWithZone:zone];
        copy.updateAt = [self.updateAt copyWithZone:zone];
        copy.visible = [self.visible copyWithZone:zone];
        copy.v = self.v;
        copy.sort = [self.sort copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.ancestors = [self.ancestors copyWithZone:zone];
    }
    
    return copy;
}


@end
