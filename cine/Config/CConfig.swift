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
        let para = String.init(format: "token=%@&sitecode=cine.ios.iphone", BCUserModel.shared.token)
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
/// 上安全区高度
public let topSafeArea:CGFloat = kIsVerb_iPhoneX ? 24 : 0
/// 下安全区高度
public let bottomSafeArea:CGFloat = kIsVerb_iPhoneX ? 34 : 0
/// 上导航栏高度（包含安全区）
public let kNavigationBarHeight:CGFloat = 64 + topSafeArea
/// 详情页顶部渐变视图高度
public let kDetailTopBarHeight:CGFloat = 50 + topSafeArea
public let kStatusHeight:CGFloat = 20
/// 下导航栏盖度（包含安全区）
public var kTabBarHeight:CGFloat = 49 + bottomSafeArea
/// 支付按钮高度
public let kPayButtonHeight:CGFloat = 52
/// 根窗口宽度
let verb_width = UIScreen.main.bounds.width
let verb_height = UIScreen.main.bounds.height
public let kScreenWidth:CGFloat = verb_width > verb_height ? verb_height : verb_width
/// 根窗口高度
public let kScreenHeight:CGFloat = verb_width > verb_height ? verb_width : verb_height
/// 判断是否是 iPhoeX
public let kIsVerb_iPhoneX:Bool = isIPad ? false : (kScreenWidth == 375 && kScreenHeight == 812)
public let qRcodeWH = kScreenWidth / 2
/********************************************
 *********** 适配 iPhoneX 参数完成 ************
 ********************************************
 ********************************************
 */
