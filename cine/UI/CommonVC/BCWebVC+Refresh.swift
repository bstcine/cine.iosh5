//
//  BCWebVC+ScrollViewDelegate.swift
//  Cine.iOS
//
//  Created by 李党坤 on 2018/11/11.
//  Copyright © 2018 善恩英语. All rights reserved.
//

import UIKit

extension BCWebVC {
    
    private var isHadFresh:Bool {
        return self.webView.scrollView.mj_header != nil
    }
    
    public func addFresh() {
        self.webView.scrollView.refreshHeader(target: self, action: #selector(freshWebView))
    }
    
    public func removeFresh() {
        self.webView.scrollView.mj_header = nil
    }
    
    @objc public func freshWebView() {
        
        if self.isHadFresh {
            self.webView.scrollView.endFreshHeader()
        }
        
        let params = self.urlString.params
        let token = params?["token"] ??  ""
        
        if params == nil || token == BCUserModel.shared.token {
            
            self.showLoading()
            self.webView.reload()
            
        }else {
            
            guard let path = self.urlString.split(separator: "?").first else {
                return
            }
            var newUrlString = "\(path)"
            var hadToken:Bool = false
            for (key,value) in params! {
                var value = value
                if key == "token" {
                    value = BCUserModel.shared.token
                    hadToken = true
                }
                if newUrlString.contains("?") {
                    newUrlString = "\(newUrlString)&\(key)=\(value)"
                }else {
                    newUrlString = "\(newUrlString)?\(key)=\(value)"
                }
            }
            if !hadToken {
                newUrlString = "\(newUrlString)&token=\(BCUserModel.shared.token)"
            }
            
            self.urlString = newUrlString
        }
        
    }
    
}
