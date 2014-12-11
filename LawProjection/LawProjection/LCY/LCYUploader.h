//
//  LCYUploader.h
//  LawProjection
//
//  Created by eagle on 14/11/1.
//  Copyright (c) 2014年 duostec. All rights reserved.
//


@interface LCYUploader : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (LCYUploader*)sharedInstance;


- (void)uploadImageData:(NSData *)imageData
               progress:(NSProgress * __autoreleasing *)progress
               fileName:(NSString *)fileName
           successBlock:(void(^)(NSDictionary *object))success
            failedBlock:(void (^)(void))failed;


- (void)uploadImage:(UIImage *)image
           progress:(NSProgress * __autoreleasing *)progress
           fileName:(NSString *)fileName
       successBlock:(void(^)(NSDictionary *object))success
        failedBlock:(void (^)(void))failed;

@end
