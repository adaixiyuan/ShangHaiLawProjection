//
//  UserInfoDetail.m
//  LawProjection
//
//  Created by developer on 14-9-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "UserInfoDetail.h"
//----------------------用户信息------------------
NSString *const userConstName = @"UserDefaultName";
NSString *const userConstPass = @"UserDefaultPass";
NSString *const userConstID   = @"UserDefaultID";
NSString *const userNONLogin  = @"UserDefaultNonLogin";
NSString *const userConstPhone= @"UserDefaultPhone";
//---------------------判断应用安装状态------------
NSString *const installInfo   = @"UserIsInstall";

//---------------------手机验证码-----------------
NSString *const userCheckPhone = @"checkNum";

@implementation UserInfoDetail
static UserInfoDetail *USERDETAIL=nil;
+(UserInfoDetail *)sharedInstance
{
    static dispatch_once_t oneTime;
    dispatch_once(&oneTime, ^{
        if(USERDETAIL==nil)
        {
            USERDETAIL = [[super allocWithZone:NULL] init];
        }
    });
    return USERDETAIL;
}

// !!!:实例化
+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[UserInfoDetail alloc] init];
}

- (id)mutableCopy
{
    return [[UserInfoDetail alloc] init];
}

- (id) init
{
    if(USERDETAIL){
        return USERDETAIL;
    }
        self = [super init];
    return self;
}
// !!!:实例化结束

// !!!:设置取得用户的基本信息
- (void)setUserName:(NSString *)userName
{
    [self setUserDefault:userConstName andValue:userName];
}

- (void)setUserPhone:(NSString *)userPhone
{
    [self setUserDefault:userConstPhone andValue:userPhone];
}

- (void)setUserID:(NSString *)userID
{
    [self setUserDefault:userConstID andValue:userID];
}

- (void)setUserPass:(NSString *)password
{
    [self setUserDefault:userConstPass andValue:password];
}

- (NSString *)getUserID
{
    NSString *userTemp = [self getUserDefault:userConstID];
    if([userTemp isEqualToString:userNONLogin])
    {
        return nil;
    }
    else
    {
        return userTemp;
    }
}

- (NSString *)getUserPhone
{
    NSString *userPhone = [self getUserDefault:userConstPhone];
    if([userPhone isEqualToString:userNONLogin])
    {
        return nil;
    }
    else
    {
        return userPhone;
    }
}


- (NSString *)getUserName
{
    NSString *userTemp = [self getUserDefault:userConstName];
    if([userTemp isEqualToString:userNONLogin])
    {
        return nil;
    }
    else
    {
        return userTemp;
    }

}

- (NSString *)getUserPass
{
    NSString *userTemp = [self getUserDefault:userConstPass];
    if([userTemp isEqualToString:userNONLogin])
    {
        return nil;
    }
    else
    {
        return userTemp;
    }

}

- (void)setUserDefault:(NSString *)type andValue:(NSString *)valueNow
{
    if(valueNow == nil)
    {
        valueNow = userNONLogin;
    }
    [[NSUserDefaults standardUserDefaults] setValue:valueNow forKey:type];
}

- (void)setOthersInfo:(NSString *)infoString withKey:(NSString *)keyString
{
   [[NSUserDefaults standardUserDefaults] setValue:infoString forKey:keyString];
}

- (NSString *)getUserInfoStringWithKey:(NSString *)key
{
    return  [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

- (NSString *)getUserDefault:(NSString *)type
{
    NSString *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:type];
    if(userInfo == nil)
    {
        return userNONLogin;
    }
    else
    {
        return userInfo;
    }
}
// !!!:设置取得用户的基本信息结束


- (NSString *)getCheckPhoneRan
{
    return [self getUserDefault:userCheckPhone];
}


- (void)setCheckPhoneRan:(NSString *)randomString
{
    [self setUserDefault:userCheckPhone andValue:randomString];
}
// !!!:判断用户是否登录,用户注销

- (BOOL)isUserLogin
{
    NSString *user_id = [self getUserID];
    if(user_id == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)userLogOut
{
    [self setUserID:nil];
    [self setUserName:nil];
    //[self setUserPass:nil];
}

// !!!:判断用户是否登录,用户注销结束

// !!!:判断是否用户第一次使用这个应用

- (BOOL)isUserFirstInstall
{
    NSString *isUserInstall = [[NSUserDefaults standardUserDefaults] valueForKey:installInfo];
    if(isUserInstall == nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"install" forKey:installInfo];
        return YES;
    }
    else
    {
        return NO;
    }
}

// !!!:结束


@end
