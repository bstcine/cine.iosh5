//
//  URL+Extension.swift
//  Cine.iOS
//
//  Created by bstcine on 2018/1/30.
//  Copyright © 2018年 善恩英语. All rights reserved.
//

import Foundation
import AVFoundation

extension URL {
    /// 判断是否为可用H5路径
    public var isAllowWeb:Bool {
        return self.absoluteString.isAllowWeb
    }
    
    /// 获取参数列表
    public var params:[String:String]? {
        return self.absoluteString.params
    }
    
}

extension String {
    public var isAllowWeb:Bool {
//        let isContainAllow = self.contains("token") || self.contains("about:blank") || !self.contains("bstcine")
//        return isContainAllow
        return true
    }
    /// 获取参数列表
    public var params:[String:String]? {
        // 判断是否包含参数
        if !self.contains("?") {
            return nil
        }
        // 获取参数部分
        guard let paramString = self.split(separator: "?").last else {
            return nil
        }
        // 分割参数
        let paramValues = paramString.split(separator: "&")
        if paramValues.count == 0 {
            return nil
        }
        var paramsDict = [String:String]()
        for paramValue in paramValues {
            if paramValue == ""{
                continue
            }
            if !paramValue.contains("="){
                continue
            }
            let paramValueArr = paramValue.split(separator: "=")
            if paramValueArr.count != 2 {
                continue
            }
            
            paramsDict.updateValue(String(paramValueArr[1]), forKey: String(paramValueArr[0]))
        }
        
        return paramsDict
    }
}
