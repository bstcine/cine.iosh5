//
//  CRequestManager.h
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/10/11.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#import <Foundation/Foundation.h>

/// CError: 内部的错误类型，兼容系统错误类型
@class CHttpFilter, CError;

@interface CRequestManager : NSObject

+ (NSURLSessionDataTask *)request:(CHttpFilter *)httpFilter success:(void(^)(NSObject *result))success failure:(void(^)(CError * error))failure;

/**
 详情请求网络接口

 @param httpFilter 请求标准
 @param success 请求成功返回
 @param failure 请求失败返回
 @return 发起的请求任务
 */
+(NSURLSessionDataTask *)requestDetail:(CHttpFilter *)httpFilter
             success:(void (^)(NSObject * resultDetail))success
             failure:(void (^)(CError * error))failure ;

/**
 * 列表数组请求接口
 * @param httpFilter 请求标准
 * @param success 请求成功返回
 * @param failure 请求失败返回
 * @return 发起的请求任务
 */
+(NSURLSessionDataTask *)requestRows:(CHttpFilter *)httpFilter
                             success:(void (^)(NSArray * resultDetail))success
                             failure:(void (^)(CError * error))failure ;

/**
 @param httpFilter 请求标准
 @param success 请求成功返回
 @param failure 请求失败返回
 @return 发起的请求任务
 */
+(NSURLSessionDataTask *)requestResult:(CHttpFilter *)httpFilter
             success:(void (^)(NSDictionary * result))success
             failure:(void (^)(CError * error))failure ;

/**
 @ 验证内购支付结果
 @ result ： 支付成功/失败
 */
+(NSURLSessionDataTask *)verifyIAPWithParam:(NSDictionary *)param
                   Result:(void(^)(BOOL result))completeBlock;

/*
 @ 验证线上版本号，获取线上信息
 */
+(NSURLSessionDataTask *)getInfoWithUrl:(NSString*)url
              success:(void (^)(NSDictionary * info))success;

+(void)cancelCurrentRequest;

+(BOOL)networkStatus;

+(void)networkReachability:(void(^)(bool isReachability))completeBlock;
+(void)clearCache;

@end
