//
//  YLHttpTool.h
//
//  Created by Yuri on 16/1/21.
//  Copyright © 2016年 123. All rights reserved.
//  网络请求业务类

#import <Foundation/Foundation.h>

@interface YLHttpTool : NSObject

/**
 *  post请求
 *
 *  @param URLString   URL
 *  @param parameters  参数
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
    progress:(void (^)(NSProgress *progress))progress
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 *  get请求
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
   progress:(void (^)(NSProgress *progress))downloadPro
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

+ (void)ConnectionGET:(NSString *)URLString
           parameters:(id)parameters
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

+ (void)ConnectionPOST:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
@end
