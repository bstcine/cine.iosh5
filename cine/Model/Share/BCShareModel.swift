//
//  BCShareModel.swift
//  iPhone
//
//  Created by bstcine on 2017/11/9.
//  Copyright © 2017年 善恩英语. All rights reserved.
//

import UIKit

public class BCShareModel: NSObject {
    
    public var id:String = ""
//    public var name:String = ""
//    public var type:String = ""
//    public var slogan:String = ""
//    public var slogan_img:String = ""
//    public var integralTip:String = ""
//    public var next_button:String = ""
//    public var share_button:String = ""
//    public var background_img:String = ""
//    public var featured_video:String = ""

    public var sharelog_id:String = ""
    
    public var share_title:String = ""
    
    public var share_desc:String = ""
    
    public var share_link:String = ""
    
    public var share_imgUrl:String = ""
    
//    public var integral:String = "0"
//    public var textArr:[Any] = [Any]()
//    public var textTpl:String = ""
    
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        id = keyedValues["id"] as? String ?? ""
//        name = keyedValues["name"] as? String ?? ""
//        type = keyedValues["type"] as? String ?? ""
//        slogan = keyedValues["slogan"] as? String ?? ""
//        slogan_img = keyedValues["slogan_img"] as? String ?? ""
//        integralTip = keyedValues["point_tip"] as? String ?? ""
//        next_button = keyedValues["next_button"] as? String ?? ""
//        share_button = keyedValues["share_button"] as? String ?? ""
//        background_img = keyedValues["background_img"] as? String ?? ""
//        textArr = keyedValues["textArr"] as? [Any] ?? [Any]()
//        textTpl = keyedValues["textTpl"] as? String ?? ""
        
        sharelog_id = keyedValues["sharelog_id"] as? String ?? ""
        
        share_title = keyedValues["share_title"] as? String ?? ""
        
        share_desc = keyedValues["share_desc"] as? String ?? ""
        
        share_link = keyedValues["share_link"] as? String ?? ""
        
        share_imgUrl = keyedValues["share_imgUrl"] as? String ?? ""
        
//        featured_video = keyedValues["featured_video"] as? String ?? ""
        
    }
    
}
