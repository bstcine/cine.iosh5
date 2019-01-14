//
//  AppDelegate.swift
//  iPhone
//
//  Created by 李党坤 on 2019/1/8.
//  Copyright © 2019 com.bstcine.www. All rights reserved.
//

import UIKit
import cine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func startApp() {
        let rootWindown = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = BCHomeVC()
        rootWindown.rootViewController = homeVC
        rootWindown.makeKeyAndVisible()
        self.window = rootWindown
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BCUtilLogic.appLaunch(launchOptions: launchOptions)
        
        self.startApp()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            // alipay
            AliPayManager.processOrder(withPaymentResult: url) { (result) in
                guard let resultDict = result as? [String:Any] else{
                    return
                }
                let resultStatus = resultDict["resultStatus"] as? String ?? "0"
                if resultStatus == "9000" {
                    // 成功
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(message: "支付成功")
                        self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                    }
                    
                }else if resultStatus == "6001" {
                    // 失败
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(message: "支付失败")
                        self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
            return true
        }
        return BCUtilLogic.wechatHandleOpen(url: url)
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return BCUtilLogic.wechatHandleOpen(url: url)
    }

}

