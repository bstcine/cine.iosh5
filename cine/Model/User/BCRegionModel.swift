//
//  BCRegionModel.swift
//  iPhone
//
//  Created by Li Ming on 16/10/2017.
//  Copyright © 2017 善恩英语. All rights reserved.
//

import UIKit

public class BCRegionModel: CBaseModel {
    
    public var code:String = "86"
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        code = keyedValues["code"] as? String ?? "86"
        
    }
}
