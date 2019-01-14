//
//  CHttpFilter.h
//  Cine.iOS
//
//  Created by Joe Lin on 10/17/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface CHttpFilter : NSObject

/**
 请求路径
 */
@property (nonatomic, copy)   NSString * path;

/**
 请求体
 */
@property (nonatomic, strong) NSDictionary * requestData;

/**
 是否需要缓存
 */
@property (nonatomic, assign) BOOL needSaveCache;

/**
 请求标识
 */
@property (nonatomic, copy  ) NSString *requestKey;

/**
 内购特殊处理标识
 */
@property (nonatomic, assign) BOOL dealReview;

/**
 要封装的模型
 */
@property (nonatomic, assign) Class modelClass;

@end
