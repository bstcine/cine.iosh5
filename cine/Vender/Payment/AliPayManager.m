//
//  AliPayManager.m
//  Cine.iOS
//
//  Created by bstcine on 2017/10/25.
//  Copyright © 2017年 善恩英语. All rights reserved.
// 

#import "AliPayManager.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AliPayManager
+ (void)processOrderWithPaymentResult:(NSURL *)url standbyCallback:(void(^)(NSDictionary *))completionBlock {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:completionBlock];
}
+ (void) alipayWithData:(NSDictionary *)dict callBack:(void(^)(NSDictionary *))completionBlock {
    NSString *pay_url = dict[@"pay_url"];
    [[AlipaySDK defaultService] payOrder:pay_url fromScheme:@"bstcine" callback:completionBlock];
}

@end
