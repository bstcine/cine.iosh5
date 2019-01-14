//
//  BCMarketVC.swift
//  iPhone
//
//  Created by 李党坤 on 2019/1/11.
//  Copyright © 2019 com.bstcine.www. All rights reserved.
//

import UIKit
import cine
import WebKit

class BCMarketVC: BCWebVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlString = H5_URL_STRING(path: .market)
    }
    
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        
    }
}
