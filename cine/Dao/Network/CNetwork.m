//  BCNetwork.m
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/9/30.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#import "CNetwork.h"
#import "CNetworkConfig.h"
#import <AFNetworking/AFNetworking.h>

@interface CNetwork()

@property (nonatomic, retain) AFHTTPSessionManager * manager;
@property (nonatomic, retain) AFNetworkReachabilityManager * reachabilityManager;

@end

@implementation CNetwork

/**
 * 网络请求发起者,管理所有的网络请求任务，(目前为GET,POST)
 * 修改内容: 将懒加载对象持久化
 * 修改原因: 当重复/同时发起多个任务时,每次都会创建一个管理器，出现野指针问题
 * 修改时间: 2018.7.20
 */
-(AFHTTPSessionManager *)manager {
    
    if (_manager == nil) {
        // 请求地址配置
        NSURL * baseURL = [NSURL URLWithString: kBSCineDomain];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.sharedContainerIdentifier = @"com.bstcine.course";
        configuration.HTTPMaximumConnectionsPerHost = 5;
        configuration.timeoutIntervalForRequest = 10;
        
        // 请求管理者配置
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer.HTTPShouldHandleCookies = false;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/javascript", nil];
    }
    
    return _manager;
}

/**
 * 实现对象地址唯一，深度单利
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [CNetwork shareManager];
}
/**
 * 实现拷贝地址唯一
 */
-(instancetype)copy {
    return [CNetwork shareManager];
}
/**
 * 实现单利对象
 */
+(instancetype)shareManager {
    static CNetwork * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ super allocWithZone:NULL] init];
    });
    return instance;
}
/**
 * 取消所有执行中的网络任务
 */
+(void)cancelTask{
//    [[CNetwork shareManager].manager invalidateSessionCancelingTasks:true];
//    [CNetwork shareManager].manager = NULL;
}

#pragma mark - 网络方法·目前定义为发起请求，不进行结果处理的响应
/**
 * 发起GET请求，获取网端数据
 * @param path : 相对路径
 * @param params : 参数
 * @param success: Block回调，请求成功后的回调结果
 * @param failure: Block回调，请求失败的回调
 * @return : NSURLSessionDataTask，发起的网络请求任务
 */
+(NSURLSessionDataTask *)get:(NSString *)path
   params:(NSDictionary *)params
   success:(void (^)(id))success
   failure:(void (^)(NSError *))failure {
    
   NSURLSessionDataTask *task = [[CNetwork shareManager].manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    return task;
}

/**
 * 发起POST请求，获取网端数据
 * @param path : 相对路径
 * @param params : 参数
 * @param success: Block回调，请求成功后的回调结果
 * @param failure: Block回调，请求失败的回调
 * @return : NSURLSessionDataTask，发起的网络请求任务
 */
+(NSURLSessionDataTask *)post:(NSString *)path params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSURLSessionDataTask *task = [[CNetwork shareManager].manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = responseObject[@"result"];
        if (![result isKindOfClass:[NSDictionary class]]) {
            success(responseObject);
            return;
        }
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}

/**
 * 监听网络状态
 * @param wifiBlock 当网络状态变为wifi时的回调
 * @param wwanBlock 当网络状态变为蜂窝移动数据的时的回调
 * @param failure 当网络断开时候的回调
 */
+(void)networkReachability:(dispatch_block_t)wifiBlock
                 wwanBlock:(dispatch_block_t)wwanBlock
                   failure:(dispatch_block_t)failure {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 目前来说了解到的只有两种网络服务提供：WWAN(蜂窝移动数据) 和 WiFi(无线网)
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown:
                
                wwanBlock();
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                
                failure();
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                wifiBlock();
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                wwanBlock();
                break;
        }
    }];
}

/**
 * 获取网络状态
 * @return 网络连接状态
 */
+(BOOL)netWorkStatus {
    
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    return reachability.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

@end

