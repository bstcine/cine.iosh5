//
//  AliPayManager.h
//  Cine.iOS
//
//  Created by bstcine on 2017/10/25.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayManager : NSObject

+ (void)processOrderWithPaymentResult:(NSURL *)url standbyCallback:(void(^)(NSDictionary *))completionBlock;
+ (void) alipayWithData:(NSDictionary *)dict callBack:(void(^)(NSDictionary *))completionBlock ;

@end
