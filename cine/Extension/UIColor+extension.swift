//
//  UIColor+extension.swift
//  cine
//
//  Created by 李党坤 on 2019/1/15.
//  Copyright © 2019 com.bstcine.www. All rights reserved.
//

import Foundation

extension UIColor {
    
    // 十六进制转换
    public static func RGB(RGBValue:Int) -> UIColor{
        return UIColor(red: ((CGFloat)((RGBValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((RGBValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(RGBValue & 0xFF))/255.0, alpha: 1.0)
    }
    public static func RGB(RGBValue:Int, alpha:CGFloat) -> UIColor{
        return UIColor(red: ((CGFloat)((RGBValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((RGBValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(RGBValue & 0xFF))/255.0, alpha: alpha)
    }
    // 十进制转换
    public static func UIColorRgb(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
}
