//
//  BCH5URLProtocol+Register.swift
//  H5Test
//
//  Created by 李党坤 on 2018/7/17.
//  Copyright © 2018年 com.bstcine.www. All rights reserved.
//

import WebKit

fileprivate let ShareProgressPool:WKProcessPool = WKProcessPool.init()
fileprivate var hadRegister:Bool = false
/**@ 注册WKWebView使拦截request
 *
 * @param schemes,需要拦截的scheme数组, 常用scheme如"http","https","file"
 * @param webView,参与注册的WKWebView对象，有时需要改变该对象的progressPool属性
 * @param hadShareProgressPool,注册的webView对象是否包含一个单利的progressPool
 * 如果没有，注册时将会给webView对象一个持久化的progressPool
 *
 * @notice :需要特别注意的是，注册了scheme之前，你必须保证正在使用的WKWebView对象配置的progressPool属性是一个单利对象，否则将可能引起crash
 */
public func RegisterWkWebView(schemes:[String]){
    
    if hadRegister {
        return
    }
    hadRegister = true
    
    let _ = BCH5UrlProtocol.initCachePath()
    URLProtocol.registerClass(BCH5UrlProtocol.self)
    
    let contextController = ["Controller","Context","Browsing","K","W"]
    let clsName = contextController.reversed().joined(separator: "")
    
    guard let cls = NSClassFromString(clsName) as? NSObject.Type else {
        return
    }
    
    let sel = NSSelectorFromString("registerSchemeForCustomProtocol:")
    
    if cls.responds(to: sel) {
        
        for scheme in schemes {
            cls.perform(sel, with: scheme)
        }
    }
}

/**@ 反注册WKWebView,结束拦截request
 *
 * @param schemes,结束拦截的scheme数组, 常用scheme如"http","https","file"
 */
public func UNRegisterWKWebView(schemes:[String]) {
    
    if !hadRegister {
        return
    }
    hadRegister = false
    
    BCH5UrlProtocol.unregisterClass(BCH5UrlProtocol.self)
    BCH5UrlProtocol.clearPostData()
    let contextController = ["Controller","Context","Browsing","K","W"]
    let clsName = contextController.reversed().joined(separator: "")
    guard let cls = NSClassFromString(clsName) as? NSObject.Type else {
        return
    }
    let sel = NSSelectorFromString("unregisterSchemeForCustomProtocol:")
    
    if cls.responds(to: sel) {
        
        for scheme in schemes {
            cls.perform(sel, with: scheme)
        }
    }
    
}
