//
//  BCShareResultModel.swift
//  Cine.iOS
//
//  Created by 李党坤 on 2018/11/20.
//  Copyright © 2018 善恩英语. All rights reserved.
//

import UIKit

public class BCShareResultModel: CBaseModel {
    public var contentId:String = ""
    public var lessonId:String = ""
    public var orderId:String = ""
    public var type:Int = -1
    public var status:Bool = false
    
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        
        contentId = keyedValues["content_id"] as? String ?? ""
        lessonId = keyedValues["lesson_id"] as? String ?? ""
        orderId = keyedValues["order_id"] as? String ?? ""
        type = (keyedValues["type"] as? String ?? "-1").int
        status = (keyedValues["status"] as? String ?? "0").bool
    }
}
