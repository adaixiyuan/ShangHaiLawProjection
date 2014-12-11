//
//  LCYNetworking.m
//  LawProjection
//
//  Created by eagle on 14/11/2.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYNetworking.h"
#import <AFNetworking/AFNetworking.h>

@implementation LCYNetworking

static LCYNetworking *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

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
    return [[LCYNetworking alloc] init];
}

- (id)mutableCopy
{
    return [[LCYNetworking alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}

- (void)postRequestWithApi:(NSString *)api parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))successBlock failed:(void (^)(void))failBlock{
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    NSString *URLString = [NSString stringWithFormat:@"%@%@?_csrf=%@", API_HOST_URL, api, afterCSRF];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response string===>%@", operation.responseString);
        
        // 刷新CSRF
        NSDictionary *currentHeader = [operation.response allHeaderFields];
        NSString *csrfString = [ZXY_APIFiles getCSRFToken:currentHeader];
        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
        
        if (successBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(responseObject);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error in request! %@",error);
        if (failBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failBlock();
            });
        }
    }];
    
}

- (void)getRequestWithApi:(NSString *)api parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))successBlock failed:(void (^)(void))failBlock{
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    NSString *URLString = [NSString stringWithFormat:@"%@%@?_csrf=%@", API_HOST_URL, api, afterCSRF];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response string===>%@", operation.responseString);
        
        // 刷新CSRF
        NSDictionary *currentHeader = [operation.response allHeaderFields];
        NSString *csrfString = [ZXY_APIFiles getCSRFToken:currentHeader];
        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
        
        if (successBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(responseObject);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error in request! %@",error);
        if (failBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failBlock();
            });
        }
    }];
}

- (void)putRequestWithApi:(NSString *)api parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))successBlock failed:(void (^)(void))failBlock{
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    NSString *URLString = [NSString stringWithFormat:@"%@%@?_csrf=%@", API_HOST_URL, api, afterCSRF];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager PUT:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response string===>%@", operation.responseString);
        
        // 刷新CSRF
        NSDictionary *currentHeader = [operation.response allHeaderFields];
        NSString *csrfString = [ZXY_APIFiles getCSRFToken:currentHeader];
        [[UserInfoDetail sharedInstance] setOthersInfo:csrfString withKey:ZXY_VALUES_CSRF];
        
        if (successBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(responseObject);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error in request! %@",error);
        if (failBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failBlock();
            });
        }
    }];
}


@end
