//
//  index.swift
//  Cine.iOS
//
//  Created by Joe Lin on 10/17/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

import UIKit

public class BCAuthLogic:BCBaseLogic {
    
    /// 登出账户
    public class func signOut(){
        
        BCUserModel.shared.token = ""
        BCUserModel.shared.userId = ""
    }
    /// 登入账户
    public class func signIn(){
        
        
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
            
            let userDict = resultDict["user"] as! [String:Any]
            BCUserModel.shared.setValuesForKeys(userDict)
            
            BCUserModel.shared.token = resultDict["token"] as? String ?? ""
            
            success(true)
            
        }, failure: failure)
        
    }
    
}
