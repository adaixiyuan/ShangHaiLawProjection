//
//  LCYUploader.m
//  LawProjection
//
//  Created by eagle on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import "LCYUploader.h"
#import <AFNetworking/AFNetworking.h>

@implementation LCYUploader

static LCYUploader *SINGLETON = nil;

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
    return [[LCYUploader alloc] init];
}

- (id)mutableCopy
{
    return [[LCYUploader alloc] init];
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

- (void)uploadImageData:(NSData *)imageData progress:(NSProgress *__autoreleasing *)progress fileName:(NSString *)fileName successBlock:(void (^)(NSDictionary *))success failedBlock:(void (^)(void))failed {
    
    NSString *csrfString = [[UserInfoDetail sharedInstance] getUserInfoStringWithKey:ZXY_VALUES_CSRF];
    NSString *afterCSRF  = [ZXY_APIFiles encode:csrfString];
    NSString *URLString = [API_HOST_URL stringByAppendingString:[NSString stringWithFormat:@"file/upload.json?_csrf=%@",afterCSRF]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
    } error:nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  if (error) {
                                                                      NSLog(@"Error in progress: %@", error);
                                                                      if (failed) {
                                                                          dispatch_async(dispatch_get_main_queue(), failed);
                                                                      }
                                                                  } else {
                                                                      NSDictionary *dic = responseObject;
                                                                      NSLog(@"response object = %@", dic);
                                                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                                      NSString *token = httpResponse.allHeaderFields[@"csrftoken"];
                                                                      if (token) {
                                                                          [[UserInfoDetail sharedInstance] setOthersInfo:token withKey:ZXY_VALUES_CSRF];
                                                                      }
                                                                      
                                                                      if (success) {
                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                              success(dic);
                                                                          });
                                                                      }
                                                                  }
                                                              }];
    
    [uploadTask resume];
}


@end
