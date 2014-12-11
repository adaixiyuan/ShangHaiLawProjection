//
//  ZXYFileOperateHelper.h
//  LawProjection
//
//  Created by developer on 14-9-17.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  此类用于文件操作
 */
@interface ZXYFileOperateHelper : NSFileManager

/**
 *  实例化方法
 *
 *  @return 实例化对象
 */
+ (ZXYFileOperateHelper *)sharedInstance;

/**
 *  返回Document文件夹路径
 *
 *  @return Document
 */
- (NSString *)documentPath;

/**
 *  temp文件夹路径
 *
 *  @return 返回temp文件夹路径
 */
- (NSString *)tempPath;

/**
 *  catche文件夹路径
 *
 *  @return 返回catche文件夹路径
 */
- (NSString *)cathePath;
@end
