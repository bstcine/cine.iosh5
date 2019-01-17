//
//  BCUserModel.swift
//  Cine.iOS
//
//  Created by 曾政桦 on 2017/10/11.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

public class BCUserModel: CBaseModel{
    
    @objc public var token:String = ""
    @objc public var userName : String = ""
    @objc public var userId : String = ""
    @objc public var login:String = ""
    public var phone : String = ""
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        
        userId = keyedValues["id"] as? String ?? ""
        login = keyedValues["login"] as? String ?? ""
        phone = keyedValues["phone"] as? String ?? ""
        token = keyedValues["token"] as? String ?? ""
    }
}
