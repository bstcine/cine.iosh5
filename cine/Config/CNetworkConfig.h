//
//  CNetworkConfig.h
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/10/13.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

#ifndef CNetworkConfig_h
#define CNetworkConfig_h

/**@ 项目配置
 *  @ 配置使用服务器类型，是否测试服务器
 *  @ 配置是否允许未登录购买
 */
#import <Foundation/Foundation.h>

/// 是否使用测试库(上架前必须修改为0)
#define ISTESTSERVICE 1

/// 判断是否是测试库
#if ISTESTSERVICE
    // 测试服务器
    NSString static *kBSCineDomain = @"https://dev.bstcine.com";

#else
    // 线上正式服务器
    NSString static *kBSCineDomain = @"https://www.bstcine.com";

#endif


#endif /* CNetworkConfig_h */

