//
//  index.swift
//  Cine.iOS
//
//  Created by Joe Lin on 10/17/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

import UIKit

public class BCAuthLogic:BCBaseLogic {
    
    private static let userModel:BCUserModel = BCUserModel()
    @objc public class func getUserModel()->BCUserModel {
        return userModel
    }
    
    public class func setAuthInfo(_ info:[String:Any]) {
        let userDict = info["user"] as! [String:Any]
        userModel.setValuesForKeys(userDict)
        
        userModel.token = info["token"] as? String ?? ""
        if userModel.userId == "" {
            userModel.userId = "BestcineEducation"
        }
        NotificationCenter.default.post(name: kNotificationChangeUserStatus, object: nil)
        self.updateCache()
    }
    private class func updateCache() {
        UserDefaults.standard.set(userModel.token, forKey: "BSTCINE_TOKEN")
        UserDefaults.standard.set(userModel.userName, forKey: "BSTCINE_USERNAME")
        UserDefaults.standard.set(userModel.login, forKey: "BESTCINE_LOGIN")
        UserDefaults.standard.set(userModel.userId, forKey: "BESTCINE_USERID")
    }
    public class func startAutInfo () {
        userModel.token = UserDefaults.standard.string(forKey: "BSTCINE_TOKEN") ?? ""
        userModel.userName = UserDefaults.standard.string(forKey: "BSTCINE_USERNAME") ?? ""
        userModel.userId = UserDefaults.standard.string(forKey: "BESTCINE_USERID") ?? "BestcineEducation"
        userModel.login = UserDefaults.standard.string(forKey: "BESTCINE_LOGIN") ?? ""
    }
    
    /// 登出账户
    public class func signOut(){
        
        userModel.token = ""
        userModel.userId = ""
    }
    
    /// 登录
    public class func login(account:String,password:String,success:@escaping ((Bool)->Void), failure:@escaping ((CError?)->Void)){
        let device = UIDevice.current
        let uuid = device.identifierForVendor!.uuidString
        
        let _httpFilter = CHttpFilter()
        _httpFilter.path = _APIURL_Auth_Login
        _httpFilter.requestData = ["phone":account,"password":password,"device_uid":uuid]
        
        CRequestManager.requestResult(_httpFilter, success: { (result) in
            
            guard let resultDict = result as? [String:Any] else{
                success(false)
                return
            }
            
            self.setAuthInfo(resultDict)
            
            success(true)
            
        }, failure: failure)
        
    }
    
}
