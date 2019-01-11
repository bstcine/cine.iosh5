//
//  BCUtilLogic.swift
//  iPhone
//
//  Created by Joe Lin on 10/30/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

import Foundation

public class BCUtilLogic: NSObject {
    
    /// app 启动时调用
    public class func appLaunch(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
       
        /// 向 wechatsdk注册 appId
        BCUtilLogic.registerWechat(appId: "wx249c741c50a289a0")
        
    }
    
    /// 注册微信 appId
    public class func registerWechat(appId:String){
        WXApiManager.registerWechat(withAppID: appId)
    }
    
    /// 微信 openUrl
    public class func wechatHandleOpen(url:URL) -> Bool{
        return WXApiManager.handleOPenUrl(url)
    }
}

