//
//  ZXYFileOperateHelper.m
//  LawProjection
//
//  Created by developer on 14-9-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "ZXYFileOperateHelper.h"

@implementation ZXYFileOperateHelper
static ZXYFileOperateHelper *operateHelper=nil;
+ (ZXYFileOperateHelper *)sharedInstance
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
       if(operateHelper == nil)
       {
           operateHelper = [[super allocWithZone:NULL] init];
       }
    });
    return operateHelper;
}

// !!!:实例化
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)mutableCopy
{
    return [[ZXYFileOperateHelper alloc] init];
}

- (id)copy
{
    return [[ZXYFileOperateHelper alloc] init];
}

- (id)init
{
    if(operateHelper)
    {
        return operateHelper;
    }
    else
    {
        self = [super init];
        return self;
    }
}
// !!!:实例化结束
-(NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(NSString *)cathePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(NSString *)tempPath
{
    NSString *path = NSTemporaryDirectory();
    return path;
}

@end
