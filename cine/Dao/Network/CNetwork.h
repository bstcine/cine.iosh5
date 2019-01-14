//
//  BCNetwork.h
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/9/30.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络层：正常来说只有「网络接触层」调用。
 */
@interface CNetwork : NSObject


/**
 网络模块Get方法
 
 @param path 请求路径
 @param params 请求参数
 @param success 响应成功回调
 @param failure 响应失败回调
 */
+(NSURLSessionDataTask *)get:(NSString *)path
    params:(NSDictionary *)params
   success:(void (^)(id json))success
   failure:(void (^)(NSError *error))failure;


/**
 网络模块Post方法
 
 @param path 请求路径
 @param params 请求参数
 @param success 响应成功回调
 @param failure 响应失败回调
 */
+(NSURLSessionDataTask *)post:(NSString *)path
     params:(NSDictionary *)params
    success:(void (^)(id json))success
    failure:(void (^)(NSError *error))failure;

/**
 网络模块reachability方法,是否需要在应用内设置相关属性关闭？
 
 @param wifiBlock wifi环境回调
 @param wwanBlock wwan环境回调
 @param failure 网络不可访问回调
 */
+(void)networkReachability:(dispatch_block_t)wifiBlock
                 wwanBlock:(dispatch_block_t)wwanBlock
                   failure:(dispatch_block_t)failure;

/**
 @ 网络模块判断是否存在网络方法
 
 @return 是否存在网络
 */
+(BOOL)netWorkStatus;

/**
  取消网络任务
 */
+(void)cancelTask;

@end

