//
//  CRequestManager.m
//  Cine.iOS
//  
//  Created by 曾政桦 on 2017/10/11.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRequestManager.h"
#import "CNetwork.h"
#import "CRequestParseManager.h"
#import "CHttpFilter.h"
#import "CError.h"
#import <cine/cine-Swift.h>
#import "CAPICacheManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation CRequestManager

+(NSURLSessionDataTask *)request:(CHttpFilter *)httpFilter success:(void (^)(NSObject *))success failure:(void (^)(CError *))failure {
    NSDictionary * _httpBody = [CRequestParseManager getHttpRequestBodyWithData:httpFilter.requestData];
    NSURLSessionDataTask *task = [CNetwork get:httpFilter.path params:_httpBody success:^(id json) {
        NSDictionary * responseDict = [CRequestParseManager getHttpResponse:json];
        if (responseDict[@"error"]) {
            failure(responseDict[@"error"]);
        }else {
            success(responseDict);
        }
    } failure:^(NSError *error) {
        CError * cError = [[CError alloc] init];
        cError.error = error;
        failure(cError);
    }];
    return task;
}

+ (NSURLSessionDataTask *)requestDetail:(CHttpFilter *)httpFilter success:(void (^)(NSObject *))success failure:(void (^)(CError *))failure {
    
    NSURLSessionDataTask *task = [self requestResult:httpFilter success:^(NSDictionary *result) {
        
        NSDictionary * detailDict = result[@"detail"];
        
        Class ModelClass = httpFilter.modelClass;
        NSObject * model = [ModelClass new];
        [model setValuesForKeysWithDictionary:detailDict];
        
        success(model);
        
    } failure:^(CError *error) {
        failure(error);
    }];
    
    return task;
}
+ (NSURLSessionDataTask *)requestRows:(CHttpFilter *)httpFilter success:(void (^)(NSArray *))success failure:(void (^)(CError *))failure {
    
    NSURLSessionDataTask *task = [self requestResult:httpFilter success:^(NSDictionary *result) {
        
        NSArray<NSDictionary *> * rowsDict = result[@"rows"];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dict in rowsDict) {
            Class ModelClass = httpFilter.modelClass;
            NSObject * model = [ModelClass new];
            [model setValuesForKeysWithDictionary:dict];
            [models addObject:model];
        }
        
        success(models);
        
    } failure:^(CError *error) {
        failure(error);
    }];
    
    return task;
}

+(NSURLSessionDataTask *)requestResult:(CHttpFilter *)httpFilter
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(CError *))failure{
    
    BOOL noNetwork = ![self networkStatus];
    
    if (noNetwork && httpFilter.needSaveCache) {
        
        NSDictionary *obj = [[CAPICacheManager sharedManager] responseWithRequest:httpFilter];
        
        if (obj != nil && obj.count > 0) {
            success(obj);
            
            return nil;
        }
        
    }
    
    NSDictionary * _httpBody = [CRequestParseManager getHttpRequestBodyWithData:httpFilter.requestData];
    
    NSURLSessionDataTask * task = [CNetwork post:httpFilter.path params:_httpBody success:^(id response) {
        
        NSDictionary * responseDict = [CRequestParseManager getHttpResponse:response];
        
        if (responseDict[@"error"]) {
            failure(responseDict[@"error"]);
        } else {
            
            NSDictionary *resultDict = responseDict[@"result"];
            BOOL isResult = [resultDict isKindOfClass:[NSDictionary class]];
            
            if (isResult) {
                success(resultDict);
            }else {
                resultDict = @{@"result":resultDict};
                success(resultDict);
            }
            
            if (httpFilter.needSaveCache) {
                [[CAPICacheManager sharedManager] saveResponse:resultDict withRequest:httpFilter];
                
            }
        }
        
    } failure:^(NSError *error) {
        
        if (httpFilter.needSaveCache) {
            NSDictionary *obj = [[CAPICacheManager sharedManager] responseWithRequest:httpFilter];
            if (obj != nil && obj.count > 0) {
                success(obj);
                return;
            }
        }
        
        CError * cerror = [CError new];
        cerror.error = error;
        if (error.code == -1001) {
            cerror.except_case_desc = @"network_timeout";
        }
        
        failure(cerror);
    }];
    
    return task;
}

+ (NSURLSessionDataTask *) verifyIAPWithParam:(NSDictionary *)param
                     Result:(void(^)(BOOL result))completeBlock {
    
    NSURLSessionDataTask *task = [CNetwork post:@"/api/app/pay/apple/verify" params:param success:^(id json) {
        
        NSDictionary *verifyDict = json;
        
        NSString *status = verifyDict[@"status"];
        
        if (status.boolValue) {
            completeBlock(true);
        }else {
            NSString *message = verifyDict[@"msg"];
            if (message != nil) {
                if ([message isEqualToString:@"order_already_paid"]) {
                    completeBlock(true);
                    return;
                }
                
                completeBlock(false);
                
                return;
            }else{
                
                completeBlock(false); // 验证失败
                
                return;
            }
        }
        
    } failure:^(NSError *error) {
        
        completeBlock(false);
        
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)getInfoWithUrl:(NSString *)url success:(void (^)(NSDictionary *))success {
    NSURLSessionDataTask *task = [CNetwork post:url params:nil success:^(id json) {
        
        NSDictionary *versionDict = json;
        success(versionDict);
        
    } failure:^(NSError *error) {
        
    }];
    
    return task;
}

+(void)cancelCurrentRequest{
    [CNetwork cancelTask];
}

+(BOOL)networkStatus {
    
    return [CNetwork netWorkStatus];
}

+ (void)networkReachability:(void(^)(bool isReachability))completeBlock {
    
    [CNetwork networkReachability:^{
        
        completeBlock(true);
        
    } wwanBlock:^{
        
        completeBlock(true);
        
    } failure:^{
        
        completeBlock(false);
        
    }];
    
}

+(void)clearCache{
    
    [CAPICacheManager deleteDataBase];
    
}

@end
