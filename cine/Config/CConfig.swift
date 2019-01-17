//
//  CConfig.swift
//  iPhone
//
//  Created by bstcine on 2017/10/26.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

/// 通用参数（token,sitecode）
public var commonPara:String {
    get{
        let para = String.init(format: "token=%@&sitecode=cine.ios.iphone", BCAuthLogic.getUserModel().token)
        return para
    }
}

/// 配置设备信息(判断是否为 iPad)
public let isIPad:Bool = {
    
    guard let bundleId = Bundle.main.bundleIdentifier else {
        return false
    }
    if bundleId == "com.iPad" {
        return true
    }
    
    return false
}()

/*******************************************
 *******************************************
 ******适配iPhoneX的尺寸需求，提供必要的方法******
 *******************************************
 */
/// 上导航栏高度（包含安全区）
public let kNavigationBarHeight:CGFloat = 64
public let kStatusHeight:CGFloat = 20
/// 下导航栏盖度（包含安全区）
public var kTabBarHeight:CGFloat = 49

/********************************************
 *********** 适配 iPhoneX 参数完成 ************
 ********************************************
 ********************************************
 */
