//
//  BCBaseLogic.swift
//  iPhone
//
//  Created by bstcine on 2017/10/24.
//  Copyright © 2017年 善恩英语. All rights reserved.
//


public class BCBaseLogic: NSObject {
    
    public class func getResult(httpFilter: CHttpFilter,
                                success: @escaping (([AnyHashable:Any]?)->Void),
                                failure: @escaping ((CError?)->Void)) {
        CRequestManager.request(httpFilter, success: { (obj) in
            success(obj as? [AnyHashable : Any])
        }) { (cError) in
            failure(cError)
        }
    }
    
}
