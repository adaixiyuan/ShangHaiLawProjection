//
//  LCYNetworking.h
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

@interface LCYNetworking : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYNetworking*)sharedInstance;

- (void)postRequestWithApi:(NSString *)api
                parameters:(NSDictionary *)parameters
                   success:(void (^)(NSDictionary * responseObject))successBlock
                    failed:(void (^)(void))failBlock;

- (void)getRequestWithApi:(NSString *)api
               parameters:(NSDictionary *)parameters
                  success:(void (^)(NSDictionary * responseObject))successBlock
                   failed:(void (^)(void))failBlock;

- (void)putRequestWithApi:(NSString *)api
               parameters:(NSDictionary *)parameters
                  success:(void (^)(NSDictionary * responseObject))successBlock
                   failed:(void (^)(void))failBlock;
@end
