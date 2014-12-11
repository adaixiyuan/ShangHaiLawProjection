//
//  LawEntityHelper.m
//  LawProjection
//
//  Created by developer on 14-10-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LawEntityHelper.h"
#import "ZXYProvider.h"
#import "AppDelegate.h"
#import "UserServiceInfo.h"
#import "AllServiceType.h"
#import "LawCaseTypeEntity.h"
#import "ContractType.h"
#import "JSONAccer/ZXY_ContractJsonHeader.h"

@implementation LawEntityHelper

+ (BOOL)saveUserInfo:(NSDictionary*)userInfo
{
    NSDictionary *dataDic = [userInfo objectForKey:@"data"];
    NSString     *idString= [dataDic objectForKey:@"id"];
    NSNumber     *validNum= [dataDic objectForKey:@"valid"];
    NSString     *_idString=[dataDic objectForKey:@"_id"];
    NSNumber     *typeNum = [dataDic objectForKey:@"type"];
    //NSString     *createAtString = [dataDic objectForKey:@"createAt"];
    //NSString     *updateAtString = [dataDic objectForKey:@"updateAt"];
    NSDictionary *extendDic      = [dataDic objectForKey:@"extend"];
    //NSString     *mobileString   = [extendDic objectForKey:@"mobile"];
    NSDictionary *areaDic     = [extendDic objectForKey:@"area"];
    NSDictionary *provinceDic = [areaDic objectForKey:@"province"];
    NSDictionary *cityDic     = [areaDic objectForKey:@"city"];
    NSString *proviceStringName   = [provinceDic objectForKey:@"name"];
    NSString *proviceStringID     = [provinceDic objectForKey:@"id"];
    NSString *sexStrings          = [NSString stringWithFormat:@"%@",[extendDic objectForKey:@"sex"]];
    NSNumber *sexNum      = [NSNumber numberWithInt:sexStrings.intValue];;
//    if(sexNum == [NSNull null])
//    {
//        NSString *sexString = [extendDic objectForKey:@"sex"];
//        sexNum =
//    }
    NSString *phone1 = @"";
    NSString *phone2 = @"";
    NSString *industral = @"";
    NSString *companyRegDate = @"";
    NSString *focusString    = @"";
    NSString *birthdayString = @"";
    NSString *detailAddress  = @"";
    if([LawEntityHelper hasKey:extendDic key:@"phone1"])
    {
        phone1 = [extendDic objectForKey:@"phone1"];
    }
    if([LawEntityHelper hasKey:extendDic key:@"phone2"])
    {
        phone2 = [extendDic objectForKey:@"phone2"];
    }
    
    if([LawEntityHelper hasKey:extendDic key:@"industry"])
    {
        industral = [extendDic objectForKey:@"industry"];
    }
    if([LawEntityHelper hasKey:extendDic key:@"companyRegDate"])
    {
        companyRegDate = [extendDic objectForKey:@"companyRegDate"];
    }
    if([LawEntityHelper hasKey:extendDic key:@"focus"])
    {
        focusString = [extendDic objectForKey:@"focus"];
    }
    if([LawEntityHelper hasKey:extendDic key:@"birthday"])
    {
        birthdayString = [self dateFromISODateString:[extendDic objectForKey:@"birthday"] ];
    }
    if([LawEntityHelper hasKey:areaDic key:@"streets"])
    {
        detailAddress = [areaDic objectForKey:@"streets"];
    }

    NSString *cityStringName      = [cityDic objectForKey:@"name"];
    NSString *cityStringID        = [cityDic objectForKey:@"id"];
    NSString *customerType        = [extendDic objectForKey:@"customerType"];
    //NSNumber *ratingNum           = [extendDic objectForKey:@"rating"];
    NSString *companyNameString   = [extendDic objectForKey:@"companyName"];
    NSString *emailString         = [dataDic objectForKey:@"email"];
    NSString *nameString          = [dataDic objectForKey:@"name"];
    
    NSMutableDictionary *dicForSave = [[NSMutableDictionary alloc] init];
    [dicForSave setObject:idString forKey:@"userinfoentityID"];
    [dicForSave setObject:_idString forKey:@"userinfo_id"];
    [dicForSave setObject:validNum forKey:@"valid"];
    [dicForSave setObject:typeNum forKey:@"type"];
    [dicForSave setObject:proviceStringID forKey:@"provinceID"];
    [dicForSave setObject:proviceStringName forKey:@"provinceName"];
    [dicForSave setObject:cityStringID forKey:@"cityID"];
    [dicForSave setObject:cityStringName forKey:@"cityName"];
    [dicForSave setObject:focusString forKey:@"focus"];
    [dicForSave setObject:birthdayString forKey:@"birthday"];
    [dicForSave setObject:detailAddress  forKey:@"detailAddress"];
    if(companyNameString)
    {
        [dicForSave setObject:companyRegDate forKey:@"companyRegDate"];
        [dicForSave setObject:companyNameString forKey:@"companyName"];
    }
    [dicForSave setObject:emailString forKey:@"email"];
    [dicForSave setObject:nameString forKey:@"name"];
    [dicForSave setObject:customerType forKey:@"customerType"];
    [dicForSave setObject:phone2 forKey:@"phone2"];
    [dicForSave setObject:phone1 forKey:@"phone1"];
    [dicForSave setObject:industral forKey:@"coorbelong"];
    [dicForSave setObject:sexNum forKey:@"sexNum"];
    return [[ZXYProvider sharedInstance] saveDataToCoreData:dicForSave withDBName:@"UserInfoEntity" isDelete:YES];
}

+ (NSString *)dateFromISODateString:(NSString *)isodate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"];
    NSDate *currentDate = [dateFormatter dateFromString:isodate];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *stringDate    =    [dateFormatter stringFromDate:currentDate];
    return stringDate;
}

+ (BOOL)saveUserServiceInfo:(NSArray *)serviceInfo
{
    [[ZXYProvider sharedInstance]deleteCoreDataFromDB:@"UserServiceInfo"];
    BOOL isSuccess = YES;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    for(NSDictionary *dic in serviceInfo)
    {
        UserServiceInfo *entity = [NSEntityDescription insertNewObjectForEntityForName:@"UserServiceInfo" inManagedObjectContext:context ];
        for(int i = 0;i<dic.allKeys.count;i++)
        {
            NSString *kesCurrent = [dic.allKeys objectAtIndex:i];
            if([kesCurrent isEqualToString:@"toAllServiceType"])
            {
                NSArray *allServceTypeArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"AllServiceType" withContent:[dic objectForKey:@"categoryId"] andKey:@"serviceType"];
                if(allServceTypeArr.count>0)
                {
                    AllServiceType *allSerceType = [allServceTypeArr objectAtIndex:0];
                    [entity setValue:allSerceType forKey:@"toAllServiceType"];
                }
            }
            else if([kesCurrent isEqualToString:@"_id"])
            {
            
            }
            else
            {
                [entity setValue:[dic objectForKey:kesCurrent] forKey:kesCurrent];
            }
        }
        NSArray *allServceTypeArr = [[ZXYProvider sharedInstance] readCoreDataFromDB:@"AllServiceType" withContent:[dic objectForKey:@"serviceType"] andKey:@"categoryId"];
        if(allServceTypeArr.count>0)
        {
            AllServiceType *allSerceType = [allServceTypeArr objectAtIndex:0];
            [entity setValue:allSerceType forKey:@"toAllServiceType"];
        }

        NSError *error = nil;
        [context save:&error];
        if(error)
        {
            NSLog(@"数据库操作失败 原因是：%@",error);
            isSuccess = NO;
        }
            
    }
    return isSuccess;
}

+ (BOOL)saveCaseType:(NSArray *)caseArr
{
    [[ZXYProvider sharedInstance]deleteCoreDataFromDB:@"LawCaseTypeEntity"];
    BOOL isSuccess = YES;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    for(NSDictionary *dic in caseArr)
    {
        UserServiceInfo *entity = [NSEntityDescription insertNewObjectForEntityForName:@"LawCaseTypeEntity" inManagedObjectContext:context ];
        for(int i = 0;i<dic.allKeys.count;i++)
        {
            NSString *kesCurrent = [dic.allKeys objectAtIndex:i];
            if([kesCurrent isEqualToString:@"_id"])
            {
                [entity setValue:[dic objectForKey:kesCurrent] forKey:@"caseTypeID"];
            }
            else
            {
                @try {
                    [entity setValue:[dic objectForKey:kesCurrent] forKey:kesCurrent];
                }
                @catch (NSException *exception) {
                    NSLog(@"没有这个key -- > %@",kesCurrent);
                }
                @finally {
                    ;
                }
                
            }
        }
        NSError *error = nil;
        [context save:&error];
        if(error)
        {
            NSLog(@"数据库操作失败 原因是：%@",error);
            isSuccess = NO;
        }
        
    }
    return isSuccess;

}

+ (BOOL)saveContractType:(NSArray *)contractArr
{
    [[ZXYProvider sharedInstance]deleteCoreDataFromDB:@"ContractType"];
    BOOL isSuccess = YES;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    for(ZXYItems *dic in contractArr)
    {
        ContractType *entity = [NSEntityDescription insertNewObjectForEntityForName:@"ContractType" inManagedObjectContext:context ];
        entity.typeName  = dic.name;
        entity.contractType    = dic.categoryId;
        entity.parentID  = dic.parent;
        entity.typeValue = dic.value;
        entity.typeID    = dic.itemsIdentifier;
        
        NSError *error = nil;
        [context save:&error];
        if(error)
        {
            NSLog(@"数据库操作失败 原因是：%@",error);
            isSuccess = NO;
        }
        
    }
    return isSuccess;

}

+ (BOOL)hasKey:(NSDictionary *)dic key:(NSString *)keyTitle
{
    NSArray *allKeys = [dic allKeys];
    if([allKeys containsObject:keyTitle])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
