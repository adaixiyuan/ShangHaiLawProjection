//
//  UserInfoDetail.h
//  LawProjection
//
//  Created by developer on 14-9-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用于读取写入用户信息的类
 */
@interface UserInfoDetail : NSObject

/**
 *  实例化方法
 *
 *  @return 返回实例对象
 */
+ (UserInfoDetail *)sharedInstance;

/**
 *  储存用户密码
 *
 *  @param password 密码
 */
- (void)setUserPass:(NSString *)password;

/**
 *  储存用户名
 *
 *  @param userName 用户名
 */
- (void)setUserName:(NSString *)userName;

/**
 *  储存用户ID
 *
 *  @param userID 用户ID
 */
- (void)setUserID:(NSString *)userID;

/**
 *  存储用户电哈
 *
 *  @param userPhone 用户电话号码ß
 */
- (void)setUserPhone:(NSString *)userPhone;
/**
 *  获取用户电话号码
 *
 *  @return 用户电话号码ß
 */
- (NSString *)getUserPhone;
/**
 *  设置一些其它的用户信息
 *
 *  @param infoString   信息的值
 *  @param keyString    信息的键
 */
- (void)setOthersInfo:(NSString *)infoString withKey:(NSString *)keyString;

/**
 *  获得用户密码
 *
 *  @return 用户密码
 */
- (NSString *)getUserPass;

/**
 *  根据键获取对应的值
 *
 *  @param key 键
 *
 *  @return 值
 */
- (NSString *)getUserInfoStringWithKey:(NSString *)key;

/**
 *  获得用户名
 *
 *  @return 用户名
 */
- (NSString *)getUserName;

/**
 *  获得用户ID
 *
 *  @return 用户ID
 */
- (NSString *)getUserID;

/**
 *  获得手机验证码随机数
 *
 *  @return 返回随机数
 */
- (NSString *)getCheckPhoneRan;

/**
 *  设置手机验证码
 *
 *  @param randomString 验证码
 */
- (void)setCheckPhoneRan:(NSString *)randomString;

/**
 *  判断用户是否登录
 *
 *  @return 登录返回YES
 */
- (BOOL)isUserLogin;

/**
 *  用户注销
 */
- (void)userLogOut;

/**
 *  判断应用是不是第一次安装
 *
 *  @return D第一次安装返回YES
 */
- (BOOL)isUserFirstInstall;
@end
