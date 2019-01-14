//
//  BCUserModel.swift
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/10/11.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

public class BCUserModel: CBaseModel{
    
    private var _token : String = ""
    private var _userName : String = ""
    private var _userId : String = "BestcineEducation"
    private var _login : String = ""
    
    @objc public var token:String {
        get{
            return _token
        }
        set{
            if _token == newValue {
                return
            }
            _token = newValue
            NotificationCenter.default.post(name: kNotificationChangeUserStatus, object: nil)
            UserDefaults.standard.set(newValue, forKey: "BSTCINE_TOKEN")
        }
    }
    public var userName : String{
        get{
            return _userName
        }
        set{
            if _userName == newValue {
                return
            }
            _userName = newValue
            UserDefaults.standard.set(newValue, forKey: "BSTCINE_USERNAME")
        }
    }

    @objc public var userId : String{
        get{
            if _userId == "" {
                _userId = "BestcineEducation"
            }
            return _userId
        }
        set{
            if _userId == newValue{
                return
            }
            if newValue == "" {
                _userId = "BestcineEducation"
            }else{
                _userId = newValue
            }
            UserDefaults.standard.set(newValue, forKey: "BESTCINE_USERID")
        }
    }
    public var login:String {
        get{
            return _login
        }
        set{
            if _login == newValue{
                return
            }
            _login = newValue
            UserDefaults.standard.set(newValue, forKey: "BESTCINE_LOGIN")
        }
    }
    
    public var phone : String = ""
    
    public static let shared = BCUserModel()
    @objc public class func sharedModel()->BCUserModel{
        return shared
    }
    @objc public class func signOut(){
        BCUserModel.shared.token = ""
    }
    public override init() {
        super.init()
        
//        _token = UserDefaults.standard.string(forKey: "BSTCINE_TOKEN") ?? ""
        _userName = UserDefaults.standard.string(forKey: "BSTCINE_USERNAME") ?? ""
        _userId = UserDefaults.standard.string(forKey: "BESTCINE_USERID") ?? "BestcineEducation"
        _login = UserDefaults.standard.string(forKey: "BESTCINE_LOGIN") ?? ""
    }
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        
        userId = keyedValues["id"] as? String ?? ""
        login = keyedValues["login"] as? String ?? ""
        phone = keyedValues["phone"] as? String ?? ""
    }
}
