//
//  UserInfoEntity.h
//  LawProjection
//
//  Created by 宇周 on 14/11/6.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfoEntity : NSManagedObject

@property (nonatomic, retain) NSString * cityID;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * coorbelong;
@property (nonatomic, retain) NSString * customerType;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone1;
@property (nonatomic, retain) NSString * phone2;
@property (nonatomic, retain) NSString * provinceID;
@property (nonatomic, retain) NSString * provinceName;
@property (nonatomic, retain) NSString * registTime;
@property (nonatomic, retain) NSNumber * sexNum;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * userinfo_id;
@property (nonatomic, retain) NSString * userinfoentityID;
@property (nonatomic, retain) NSNumber * valid;
@property (nonatomic, retain) NSString * companyRegDate;
@property (nonatomic, retain) NSString * focus;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * detailAddress;

@end
