//
//  Items.m
//
//  Created by Mac  on 14-10-22
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Items.h"


NSString *const kItemsDescription = @"description";
NSString *const kItemsCategory = @"category";
NSString *const kItemsUpdateBy = @"updateBy";
NSString *const kItemsValid = @"valid";
NSString *const kItemsFileId = @"fileId";
NSString *const kItemsContentType = @"contentType";
NSString *const kItemsId = @"_id";
NSString *const kItemsLength = @"length";
NSString *const kItemsCreateAt = @"createAt";
NSString *const kItemsUpdateAt = @"updateAt";
NSString *const kItemsV = @"__v";
NSString *const kItemsName = @"name";
NSString *const kItemsCreateBy = @"createBy";


@interface Items ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Items

@synthesize itemsDescription = _itemsDescription;
@synthesize category = _category;
@synthesize updateBy = _updateBy;
@synthesize valid = _valid;
@synthesize fileId = _fileId;
@synthesize contentType = _contentType;
@synthesize itemsIdentifier = _itemsIdentifier;
@synthesize length = _length;
@synthesize createAt = _createAt;
@synthesize updateAt = _updateAt;
@synthesize v = _v;
@synthesize name = _name;
@synthesize createBy = _createBy;


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
            self.itemsDescription = [self objectOrNilForKey:kItemsDescription fromDictionary:dict];
            self.category = [self objectOrNilForKey:kItemsCategory fromDictionary:dict];
            self.updateBy = [self objectOrNilForKey:kItemsUpdateBy fromDictionary:dict];
            self.valid = [[self objectOrNilForKey:kItemsValid fromDictionary:dict] doubleValue];
            self.fileId = [self objectOrNilForKey:kItemsFileId fromDictionary:dict];
            self.contentType = [self objectOrNilForKey:kItemsContentType fromDictionary:dict];
            self.itemsIdentifier = [self objectOrNilForKey:kItemsId fromDictionary:dict];
            self.length = [[self objectOrNilForKey:kItemsLength fromDictionary:dict] doubleValue];
            self.createAt = [self objectOrNilForKey:kItemsCreateAt fromDictionary:dict];
            self.updateAt = [self objectOrNilForKey:kItemsUpdateAt fromDictionary:dict];
            self.v = [[self objectOrNilForKey:kItemsV fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kItemsName fromDictionary:dict];
            self.createBy = [self objectOrNilForKey:kItemsCreateBy fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.itemsDescription forKey:kItemsDescription];
    [mutableDict setValue:self.category forKey:kItemsCategory];
    [mutableDict setValue:self.updateBy forKey:kItemsUpdateBy];
    [mutableDict setValue:[NSNumber numberWithDouble:self.valid] forKey:kItemsValid];
    [mutableDict setValue:self.fileId forKey:kItemsFileId];
    [mutableDict setValue:self.contentType forKey:kItemsContentType];
    [mutableDict setValue:self.itemsIdentifier forKey:kItemsId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.length] forKey:kItemsLength];
    [mutableDict setValue:self.createAt forKey:kItemsCreateAt];
    [mutableDict setValue:self.updateAt forKey:kItemsUpdateAt];
    [mutableDict setValue:[NSNumber numberWithDouble:self.v] forKey:kItemsV];
    [mutableDict setValue:self.name forKey:kItemsName];
    [mutableDict setValue:self.createBy forKey:kItemsCreateBy];

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

    self.itemsDescription = [aDecoder decodeObjectForKey:kItemsDescription];
    self.category = [aDecoder decodeObjectForKey:kItemsCategory];
    self.updateBy = [aDecoder decodeObjectForKey:kItemsUpdateBy];
    self.valid = [aDecoder decodeDoubleForKey:kItemsValid];
    self.fileId = [aDecoder decodeObjectForKey:kItemsFileId];
    self.contentType = [aDecoder decodeObjectForKey:kItemsContentType];
    self.itemsIdentifier = [aDecoder decodeObjectForKey:kItemsId];
    self.length = [aDecoder decodeDoubleForKey:kItemsLength];
    self.createAt = [aDecoder decodeObjectForKey:kItemsCreateAt];
    self.updateAt = [aDecoder decodeObjectForKey:kItemsUpdateAt];
    self.v = [aDecoder decodeDoubleForKey:kItemsV];
    self.name = [aDecoder decodeObjectForKey:kItemsName];
    self.createBy = [aDecoder decodeObjectForKey:kItemsCreateBy];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_itemsDescription forKey:kItemsDescription];
    [aCoder encodeObject:_category forKey:kItemsCategory];
    [aCoder encodeObject:_updateBy forKey:kItemsUpdateBy];
    [aCoder encodeDouble:_valid forKey:kItemsValid];
    [aCoder encodeObject:_fileId forKey:kItemsFileId];
    [aCoder encodeObject:_contentType forKey:kItemsContentType];
    [aCoder encodeObject:_itemsIdentifier forKey:kItemsId];
    [aCoder encodeDouble:_length forKey:kItemsLength];
    [aCoder encodeObject:_createAt forKey:kItemsCreateAt];
    [aCoder encodeObject:_updateAt forKey:kItemsUpdateAt];
    [aCoder encodeDouble:_v forKey:kItemsV];
    [aCoder encodeObject:_name forKey:kItemsName];
    [aCoder encodeObject:_createBy forKey:kItemsCreateBy];
}

- (id)copyWithZone:(NSZone *)zone
{
    Items *copy = [[Items alloc] init];
    
    if (copy) {

        copy.itemsDescription = [self.itemsDescription copyWithZone:zone];
        copy.category = [self.category copyWithZone:zone];
        copy.updateBy = [self.updateBy copyWithZone:zone];
        copy.valid = self.valid;
        copy.fileId = [self.fileId copyWithZone:zone];
        copy.contentType = [self.contentType copyWithZone:zone];
        copy.itemsIdentifier = [self.itemsIdentifier copyWithZone:zone];
        copy.length = self.length;
        copy.createAt = [self.createAt copyWithZone:zone];
        copy.updateAt = [self.updateAt copyWithZone:zone];
        copy.v = self.v;
        copy.name = [self.name copyWithZone:zone];
        copy.createBy = [self.createBy copyWithZone:zone];
    }
    
    return copy;
}


@end
