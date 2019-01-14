//
//  CColorConfig.swift
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/10/17.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import Foundation

extension UIColor {
    
    /// 主题色，蓝色
    public static let bcTheme = UIColor.RGB(RGBValue: 0x014292)
    /// 标题色 黑色
    public static let bcTitle = UIColor.RGB(RGBValue: 0x222222)  // 默认颜色，黑
    /// 正文颜色优先，灰色
    public static let bcTextPrimary = UIColor.RGB(RGBValue: 0x7a7b7d)
    /// 正文颜色次优先，橘色
    public static let bcTextSecondary = UIColor.RGB(RGBValue: 0xfe682d)
    /// 正文颜色末优先,灰色
    public static let bcTextThirdary = UIColor.RGB(RGBValue: 0xc2c3c5)
    // 十六进制转换
    private static func RGB(RGBValue:Int) -> UIColor{
        return UIColor(red: ((CGFloat)((RGBValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((RGBValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(RGBValue & 0xFF))/255.0, alpha: 1.0)
    }
    private static func RGB(RGBValue:Int, alpha:CGFloat) -> UIColor{
        return UIColor(red: ((CGFloat)((RGBValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((RGBValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(RGBValue & 0xFF))/255.0, alpha: alpha)
    }
    // 十进制转换
    private static func UIColorRgb(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}


