//
//  BCBaseModel.swift
//  iPhone
//
//  Created by Li Ming on 16/10/2017.
//  Copyright © 2017 善恩英语. All rights reserved.
//

import UIKit

public class CBaseModel: NSObject {
    
    public var id : String = ""
    public var name : String = ""
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        id = keyedValues["id"] as? String ?? ""
        name = keyedValues["name"] as? String ?? ""
    }

}
