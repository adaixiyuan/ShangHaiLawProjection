//
//  ZXY_SystemRelative.m
//  LawProjection
//
//  Created by developer on 14-9-22.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXY_SystemRelative.h"
#import <Reachability/Reachability.h>
@implementation ZXY_SystemRelative
+(float)getCurrentSysVersion
{
    float currentVersion = [[UIDevice currentDevice] systemVersion].floatValue;
    return currentVersion;
}

+ (BOOL)isIOS7
{
    float currentVersion = [self getCurrentSysVersion];
    if(currentVersion >=7.0&&currentVersion<8.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isIOS8
{
    float currentVersion = [self getCurrentSysVersion];
    if(currentVersion >= 8.0 && currentVersion<9.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isNetAvilible
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    return reach.isReachable;
}
@end
