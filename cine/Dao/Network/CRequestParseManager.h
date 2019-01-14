//
//  CRequestParseManager.h
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/10/16.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CError;

@interface CRequestParseManager : NSObject

/**
 定义输出标准请求参数
 
 @param data 业务请求参数
 @return 标准请求参数，包含设备信息
 */
+(NSDictionary *)getHttpRequestBodyWithData:(NSDictionary *) data;


/**
 处理响应返回原始内容
 
 @param response 需进行处理的数据
 @return 输出处理结果:
 1.如果处理的结果为异常，则返回 @{"error": XXX}格式；
 2.如果处理结果为列表，则返回 @{@"result": XXXX}
 */
+(NSDictionary *)getHttpResponse:(id)response ;


@end
