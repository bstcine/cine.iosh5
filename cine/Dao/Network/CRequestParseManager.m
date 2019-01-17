//
//  CRequestParseManager.m
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/10/16.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#import "CRequestParseManager.h"
#import "CError.h"
#import <cine/cine-Swift.h>


@implementation CRequestParseManager

+(NSDictionary *) getHttpRequestBodyWithData:(NSDictionary *) data {
    
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString * _appver = dict[@"CFBundleShortVersionString"];
    NSString * _appDevice = dict[@"CFBundleExecutable"];
    NSString * _sitecode;
    if ([_appDevice isEqualToString:@"iPhone"]) {
        _sitecode = @"cine.ios.iphone";
    }else if([_appDevice isEqualToString:@"iPad"]){
        _sitecode = @"cine.ios.ipad";
    }
    NSString * _token = [BCAuthLogic getUserModel].token;
    NSString * _channel = @"";
    NSString * _locate = @"ch";
    
    return @{@"token" : _token,
             @"sitecode" : _sitecode,
             @"channel" : _channel,
             @"locale" : _locate,
             @"appver" : _appver,
             @"data" : [data copy]
             };
}

#pragma mark - 解析方法
+(NSDictionary *)getHttpResponse:(id)response {
    
    CError * cError = [self parseCError:response];
    NSDictionary * result = response[@"result"];
    
    if (cError.isExcept) {
        return @{@"error": cError};
    }
    else{
        return @{@"result": result};
    }
}

+(CError *)parseCError:(NSDictionary *)response {
    
    NSInteger code = [response[@"code"] integerValue];
    NSString * code_desc = response[@"code_desc"];
    NSString * except_case = response[@"except_case"];
    NSString * except_case_desc = response[@"except_case_desc"];
    
    CError * cError = [CError new];
    cError.isExcept = false;
    cError.code_desc = code_desc;
    cError.except_case = except_case;
    cError.except_case_desc = except_case_desc;
    
    if (code == 0)
    {
        cError.isExcept = true;
    }
    if (![except_case_desc isEqualToString:@""])
    {
        cError.isExcept = true;
    }
    
    return cError;
}


@end
